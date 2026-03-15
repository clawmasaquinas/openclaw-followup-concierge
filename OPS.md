# Live Business Ops

Top-level operator notes for the local live-business stack.

## Fast start
From `live-business/`:

```bash
./start-all.sh
```

## Fast status check
```bash
./status.sh
```

## Main parts
- `site/` — landing page + intake backend + admin view
- `data/` — captured leads
- `pilot-ops/` — client workspaces and delivery scripts

## Main URLs
When the site is running locally:
- <http://127.0.0.1:8080>
- <http://127.0.0.1:8080/admin.html>
- <http://127.0.0.1:8080/api/leads>
- <http://127.0.0.1:8080/api/leads.csv>

## Recommended daily operator check
1. run `./status.sh`
2. inspect admin page / leads
3. decide which leads are worth promotion
4. promote qualified leads into pilot ops
5. keep client workspaces updated

## Handoff docs
- `HANDOFF.md` — current state of the live-business stack
- `DEPLOYMENT_NEXT_STEPS.md` — what still needs to happen for public launch
