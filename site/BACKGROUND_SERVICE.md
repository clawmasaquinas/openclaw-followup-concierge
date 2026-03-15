# Background Service Mode

Use this when you want the local live-business service to keep running in the background with simple logging.

## Start in background
```bash
./start-bg.sh
```

## Stop background service
```bash
./stop-bg.sh
```

## View recent logs
```bash
./logs.sh
```

## Files used
- `../logs/site.log`
- `../logs/site.pid`

## Note
This is still lightweight process management, not a full systemd service. But it is enough to keep the local business stack running more reliably between interactions.
