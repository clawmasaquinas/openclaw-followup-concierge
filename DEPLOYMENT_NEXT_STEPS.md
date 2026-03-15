# Deployment Next Steps

These are the next outward-facing steps once deployment/auth paths are available.

## 1. Pick a public deployment route
Possible routes:
- static hosting + tiny Node host
- VPS / reverse proxy
- platform deploy if credentials become available

## 2. Expose the site publicly
Minimum target:
- homepage
- intake form
- thank-you page

## 3. Decide intake handling
Current state:
- local-only storage in `live-business/data/`

Public options later:
- keep Node backend and host it
- route form submissions into a simple database
- route form submissions into email/Discord/internal channel

## 4. Add basic production safeguards
Before public launch:
- rate limiting
- spam mitigation
- backup/export plan for leads
- clear operator notification path when a lead comes in

## 5. Launch sequence
- deploy
- smoke-test intake
- confirm lead persistence
- confirm admin visibility
- send first outreach batch
- monitor for first real inbound

## 6. After first real lead
- review fit
- qualify fast
- move into discovery / proposal / kickoff
- create real client workspace

## Rule
Do not overbuild before real market feedback arrives.
The next job is exposure and real conversations, not infinite local refinement.
