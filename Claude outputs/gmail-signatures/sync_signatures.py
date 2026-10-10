#!/usr/bin/env python3
"""Set every Everbetter user's Gmail signature from the Google Workspace directory.

Deterministic; no LLM calls. Dry run by default; pass --apply to write.

Auth: a service account with domain-wide delegation for two scopes:
  https://www.googleapis.com/auth/admin.directory.user.readonly  (impersonates ADMIN_EMAIL)
  https://www.googleapis.com/auth/gmail.settings.basic           (impersonates each user)

Environment (one credential mode):
  SERVICE_ACCOUNT_EMAIL           keyless (default): ADC signs JWTs via the IAM Credentials API;
                                  caller needs roles/iam.serviceAccountTokenCreator on the SA
  GOOGLE_APPLICATION_CREDENTIALS  key file mode: path to a service-account JSON key
  ADMIN_EMAIL                     a Workspace admin used for directory reads
"""

import argparse
import html
import logging
import os
import sys
from pathlib import Path

import google.auth
from google.auth import iam
from google.auth.transport.requests import Request
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

DIRECTORY_SCOPE = "https://www.googleapis.com/auth/admin.directory.user.readonly"
GMAIL_SCOPE = "https://www.googleapis.com/auth/gmail.settings.basic"
CLOUD_SCOPE = "https://www.googleapis.com/auth/cloud-platform"
TOKEN_URI = "https://oauth2.googleapis.com/token"
TEMPLATE = Path(__file__).with_name("template.html")
RETRIES = 5

log = logging.getLogger("signatures")


def load_credentials():
    """Keyless delegation when SERVICE_ACCOUNT_EMAIL is set; key file otherwise."""
    sa_email = os.environ.get("SERVICE_ACCOUNT_EMAIL")
    if sa_email:
        source, _ = google.auth.default(scopes=[CLOUD_SCOPE])
        signer = iam.Signer(Request(), source, sa_email)
        return service_account.Credentials(signer, sa_email, TOKEN_URI)
    key = os.environ.get("GOOGLE_APPLICATION_CREDENTIALS")
    if key:
        return service_account.Credentials.from_service_account_file(key)
    sys.exit("Set SERVICE_ACCOUNT_EMAIL (keyless) or GOOGLE_APPLICATION_CREDENTIALS (key file).")


def fields(user):
    """Extract signature fields from a Directory API user resource."""
    org = next((o for o in user.get("organizations", []) if o.get("primary")),
               (user.get("organizations") or [{}])[0])
    phone = next((p for p in user.get("phones", []) if p.get("primary")),
                 next((p for p in user.get("phones", []) if p.get("type") == "work"), {}))
    return {
        "name": user.get("name", {}).get("fullName", ""),
        "title": org.get("title", ""),
        "phone": phone.get("value", ""),
        "tel": "".join(c for c in phone.get("value", "") if c.isdigit() or c == "+"),
        "email": user["primaryEmail"],
    }


def render(template, values):
    """Fill the template; drop any line whose placeholder has no value."""
    lines = []
    for line in template.splitlines():
        keys = [k for k in values if "{" + k + "}" in line]
        if any(not values[k] for k in keys):
            continue
        for k in keys:
            line = line.replace("{" + k + "}", html.escape(values[k], quote=True))
        lines.append(line)
    return "\n".join(lines).strip()


def directory_users(creds, admin, domain, org_unit):
    svc = build("admin", "directory_v1",
                credentials=creds.with_scopes([DIRECTORY_SCOPE]).with_subject(admin),
                cache_discovery=False)
    query = f"orgUnitPath='{org_unit}'" if org_unit else None
    token = None
    while True:
        page = svc.users().list(domain=domain, query=query, pageToken=token,
                                maxResults=500, orderBy="email",
                                projection="full").execute(num_retries=RETRIES)
        yield from page.get("users", [])
        token = page.get("nextPageToken")
        if not token:
            return


def sync_user(creds, email, signature, apply):
    """Return 'unchanged', 'would-update' or 'updated'."""
    gmail = build("gmail", "v1",
                  credentials=creds.with_scopes([GMAIL_SCOPE]).with_subject(email),
                  cache_discovery=False)
    send_as = gmail.users().settings().sendAs()
    current = send_as.get(userId="me", sendAsEmail=email).execute(num_retries=RETRIES)
    if current.get("signature", "").strip() == signature:
        return "unchanged"
    if not apply:
        return "would-update"
    send_as.patch(userId="me", sendAsEmail=email,
                  body={"signature": signature}).execute(num_retries=RETRIES)
    return "updated"


def main():
    p = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    p.add_argument("--domain", default="everbetter.com")
    p.add_argument("--org-unit", help="limit to one OU, e.g. /Engineering")
    p.add_argument("--user", action="append", help="limit to these emails (repeatable)")
    p.add_argument("--apply", action="store_true", help="write changes; default is dry run")
    p.add_argument("--show", action="store_true", help="print each rendered signature")
    args = p.parse_args()

    logging.basicConfig(level=logging.INFO, format="%(levelname)s %(message)s")
    admin = os.environ.get("ADMIN_EMAIL")
    if not admin:
        sys.exit("Set ADMIN_EMAIL.")

    creds = load_credentials()
    template = TEMPLATE.read_text()
    wanted = {u.lower() for u in args.user or []}
    counts = {}

    for user in directory_users(creds, admin, args.domain, args.org_unit):
        email = user["primaryEmail"]
        if user.get("suspended") or user.get("archived"):
            continue
        if wanted and email.lower() not in wanted:
            continue
        signature = render(template, fields(user))
        if args.show:
            print(f"--- {email}\n{signature}\n")
        try:
            result = sync_user(creds, email, signature, args.apply)
        except HttpError as e:
            result = "error"
            log.error("%s: HTTP %s", email, e.resp.status)
        counts[result] = counts.get(result, 0) + 1
        log.info("%s: %s", email, result)

    log.info("summary %s%s", counts, "" if args.apply else " (dry run)")
    sys.exit(1 if counts.get("error") else 0)


if __name__ == "__main__":
    main()
