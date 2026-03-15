# Site

Landing page plus a minimal local intake backend for the OpenClaw Follow-up Concierge offer.

## Files
- `index.html`
- `styles.css`
- `server.js`
- `run.sh`
- `preview.sh`
- `stop.sh`
- `restart.sh`
- `status.sh`
- `start-bg.sh`
- `stop-bg.sh`
- `logs.sh`
- `manage.sh`
- `SERVICE.md`
- `BACKGROUND_SERVICE.md`

## Run locally with intake capture
Optional: copy `.env.example` to `.env` and adjust settings.

```bash
./manage.sh start
```
Then open:
- <http://127.0.0.1:8080>

## Service control
```bash
./manage.sh status
./manage.sh restart
./manage.sh stop
```

## Background mode
```bash
./manage.sh start-bg
./manage.sh logs
./manage.sh stop-bg
```

Submissions POST to `/intake` and are stored locally in:
- `../data/leads.json`
- `../data/leads.csv`

## Quick inspection
To inspect captured leads:
- open `../data/leads.json`
- visit <http://127.0.0.1:8080/api/leads>
- visit <http://127.0.0.1:8080/api/leads.csv>
- use the local admin view at <http://127.0.0.1:8080/admin.html>

## Notes
This is still intentionally lightweight and local-first, but it is now a real runnable service rather than a static placeholder.
