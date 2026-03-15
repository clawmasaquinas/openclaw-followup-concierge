# GitHub Publishing Notes

GitHub access is now available, which unlocks repo creation and GitHub-based publishing workflows.

## What GitHub is enough for
- storing the project in a repo
- versioning the live-business stack
- enabling GitHub Actions workflows
- publishing a static version of the site with GitHub Pages

## What GitHub alone is not enough for
The current local app includes a Node backend for lead intake and local data persistence.
GitHub Pages cannot run that server-side logic.

So there are two paths:

## Path A — fastest public presence
- publish static site via GitHub Pages
- use static fallback intake page or a simplified contact path
- defer full backend hosting until later

## Path B — full current functionality
- push code to GitHub
- deploy the Node service to a real app host
- preserve intake/backend/admin behavior more directly

## Recommendation
Use GitHub now to cleanly version and publish the project, but do not mistake GitHub Pages for full backend hosting.
