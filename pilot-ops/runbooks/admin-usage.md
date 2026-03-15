# Admin Usage

Use the local admin page to review captured leads quickly.

## Start the service
From `live-business/site/`:

```bash
./run.sh
```

## Admin URLs
- Site: <http://127.0.0.1:8080>
- Lead admin: <http://127.0.0.1:8080/admin.html>
- JSON API: <http://127.0.0.1:8080/api/leads>
- CSV export: <http://127.0.0.1:8080/api/leads.csv>

## Typical flow
1. review new leads in `admin.html`
2. decide if they are worth discovery
3. if yes, promote them into pilot ops
4. continue with proposal/intake/kickoff flow
