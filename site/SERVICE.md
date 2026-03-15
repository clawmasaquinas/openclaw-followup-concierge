# Local Service Management

Use these scripts to run the local live-business service more cleanly.

## Commands
From `live-business/site/`:

```bash
./manage.sh start
./manage.sh stop
./manage.sh restart
./manage.sh status
```

## Notes
- service binds to `127.0.0.1:8080`
- `stop` uses `fuser -k 8080/tcp`
- `restart` now uses the background-service flow so it returns cleanly instead of blocking in the foreground

## Main endpoints
- `/` — landing page
- `/intake` — lead intake POST target
- `/api/leads` — JSON leads
- `/api/leads.csv` — CSV export
- `/admin.html` — lead admin view
