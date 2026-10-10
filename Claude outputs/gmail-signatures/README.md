# Gmail signature sync

Sets each Everbetter user's Gmail signature from Google Workspace directory fields
(name, title, phone, email). Deterministic; zero LLM tokens. Idempotent: writes only when
the rendered signature differs from the current one.

## One-time setup (Workspace super admin)

1. Google Cloud console: create a project; enable **Admin SDK API** and **Gmail API**.
2. Create a service account; download its JSON key. Store it in a secret manager; never commit it.
3. Admin console > Security > Access and data control > API controls > Domain-wide delegation:
   add the service account client ID with scopes
   `https://www.googleapis.com/auth/admin.directory.user.readonly,https://www.googleapis.com/auth/gmail.settings.basic`
4. Populate each user's **Job title** and **Work phone** in Admin console > Directory > Users.

## Run

```bash
pip install google-api-python-client google-auth
export GOOGLE_APPLICATION_CREDENTIALS=/secure/path/key.json
export ADMIN_EMAIL=buzz@everbetter.com

python3 sync_signatures.py --user buzz@everbetter.com --show   # dry run, one user
python3 sync_signatures.py --user buzz@everbetter.com --apply  # write one user
python3 sync_signatures.py --apply                             # all active users
```

Lines with an empty field are omitted. Exit code 1 when any user fails.

## Schedule (nightly)

```cron
15 2 * * * cd /opt/gmail-signatures && python3 sync_signatures.py --apply >> /var/log/signatures.log 2>&1
```

## Test

```bash
python3 -m unittest -v
```
