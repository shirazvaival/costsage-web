#!/usr/bin/env bash
# Roll back the live costsage-web container on the Ubuntu laptop to a specific version.
#
# Usage:
#   ./rollback.sh v1.0.0           # roll back to release v1.0.0
#   ./rollback.sh sha-b171890      # roll back to a specific commit build
#   ./rollback.sh dev              # track the :dev tag again (rolls forward)
#
# Requires:
#   - Cloudflare Access SSH proxy (cloudflared) installed and authed for marketing-claude-soc.rundev.us
#   - SSH key at ~/.ssh/marketing-claude-soc (or adjust SSH_KEY below)

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <image-tag>" >&2
  echo "  e.g.  $0 v1.0.0    |   $0 sha-00e2ed3    |   $0 dev" >&2
  exit 1
fi

TAG="$1"
# Strip leading 'v' if user passed a semver tag — image tags are un-prefixed (1.0.0, not v1.0.0).
IMAGE_TAG="${TAG#v}"

SSH_KEY="${SSH_KEY:-$HOME/.ssh/marketing-claude-soc}"
SSH_HOST="root@marketing-claude-soc.rundev.us"
CF_PROXY='cloudflared access ssh --hostname %h'
IMAGE="ghcr.io/shirazvaival/costsage-web:${IMAGE_TAG}"

echo "==> Rolling back costsage-web to: ${IMAGE}"

ssh -i "${SSH_KEY}" \
    -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    -o IdentitiesOnly=yes -o PreferredAuthentications=publickey \
    -o "ProxyCommand=${CF_PROXY}" \
    "${SSH_HOST}" \
    "set -e
     docker pull '${IMAGE}'
     cd /opt/wordpress
     # Swap image tag in compose; only touch the costsage-web service line.
     sed -i -E 's|(image:\\s*ghcr\\.io/shirazvaival/costsage-web:)[^[:space:]]+|\\1${IMAGE_TAG}|' docker-compose.yml
     docker compose up -d costsage-web
     sleep 2
     echo '--- /_build ---'
     curl -s http://localhost:8090/_build"

echo "==> Done. Verify at http://10.16.140.59:8090/"
