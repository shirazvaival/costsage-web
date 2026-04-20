# CostSage Web

Static HTML site for costsage.ai (revamp). Auto-built into an nginx Docker image and published to GitHub Container Registry on every push.

## Branch → Image tag map

| Branch / Ref  | Build env  | Image tags pushed                                   |
|---------------|------------|-----------------------------------------------------|
| `main`        | `prod`     | `prod`, `latest`, `sha-<7>`, `main`                 |
| `staging`     | `staging`  | `staging`, `sha-<7>`, `staging`                     |
| `dev`         | `dev`      | `dev`, `sha-<7>`, `dev`                             |
| `vX.Y.Z` tag  | `prod`     | `X.Y.Z`, `X.Y`, `sha-<7>`                           |

Image name: `ghcr.io/shirazvaival/costsage-web`

## Editing the site

1. Edit any `site/*.html` file (copy, images, sections).
2. Commit + push to the branch matching where you want it to land:
   - `dev` — experimental, pulled by the local Ubuntu laptop
   - `staging` — for pre-prod review
   - `main` — production
3. GitHub Actions builds + publishes the image within a couple minutes.
4. The Docker host pulls the new tag and restarts.

## Local preview

```bash
docker build -t costsage-web:local .
docker run --rm -p 8080:80 costsage-web:local
# open http://localhost:8080
```

## Pull + run from GHCR

```bash
docker pull ghcr.io/shirazvaival/costsage-web:prod   # or dev, staging, sha-abc1234
docker run -d --name costsage-web -p 8080:80 \
  ghcr.io/shirazvaival/costsage-web:prod
```

To verify which build is running:

```bash
curl http://localhost:8080/_build
# env=prod
# sha=abc1234
# time=2026-04-17T12:34:56Z
```

## Auto-deploy on the Ubuntu laptop (dev)

Install a one-shot poll-and-pull (systemd timer + watchtower both work). Simplest:

```bash
# docker-compose.yml fragment
services:
  costsage-web:
    image: ghcr.io/shirazvaival/costsage-web:dev
    container_name: costsage-web
    restart: unless-stopped
    ports: ["8081:80"]
```

Pair with `containrrr/watchtower` polling every 5 minutes to auto-pull the tag.
