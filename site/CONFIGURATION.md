# Configuration

The local site can be configured through environment variables or a local `.env` file.

## Quick start
```bash
cp .env.example .env
```
Then edit values as needed.

## Supported settings
- `PORT` — default `8080`
- `HOST` — default `127.0.0.1`
- `BUSINESS_NAME` — display/log name for the service
- `ADMIN_PATH` — reserved for admin path customization

## Notes
- `.env.example` is safe to commit
- `.env` should remain local if used for machine-specific settings
