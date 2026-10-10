# Gmail signature sync

Sets each Everbetter user's Gmail signature from Google Workspace directory fields
(name, title, phone, email). Deterministic; zero LLM tokens. Idempotent: writes only when
the rendered signature differs from the current one.

## One-time setup (keyless; no JSON key)

Works when org policy `iam.disableServiceAccountKeyCreation` blocks keys.

```bash
PROJECT_ID=your-project
SA=gmail-signature-sync@$PROJECT_ID.iam.gserviceaccount.com

gcloud services enable iamcredentials.googleapis.com --project=$PROJECT_ID
gcloud iam service-accounts create gmail-signature-sync --project=$PROJECT_ID
gcloud iam service-accounts add-iam-policy-binding $SA \
  --member=user:buzz@everbetter.com --role=roles/iam.serviceAccountTokenCreator
gcloud iam service-accounts describe $SA --format='value(uniqueId)'   # Client ID
gcloud auth application-default login
```

Admin console > Security > Access and data control > API controls > Manage Domain Wide
Delegation > Add new: paste the Client ID; scopes:
`https://www.googleapis.com/auth/admin.directory.user.readonly,https://www.googleapis.com/auth/gmail.settings.basic`

Populate each user's **Job title** and **Work phone** in Admin console > Directory > Users.

## Run

```bash
pip install google-api-python-client google-auth
export SERVICE_ACCOUNT_EMAIL=$SA        # or GOOGLE_APPLICATION_CREDENTIALS=key.json
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
