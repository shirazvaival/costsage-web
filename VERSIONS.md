# CostSage Web — Version Ledger

Rollback reference. Latest on top. Every semver release should have a row here.

Pull any version:
```bash
docker pull ghcr.io/shirazvaival/costsage-web:<TAG>
```

Roll back on the Ubuntu laptop (`/opt/wordpress/docker-compose.yml`): update the image tag to the target version → `docker compose up -d costsage-web`.

---

## v1.1.0 — 2026-04-22

- **Commit:** (set after push)
- **Image:** `ghcr.io/shirazvaival/costsage-web:1.1.0`
- **Release:** https://github.com/shirazvaival/costsage-web/releases/tag/v1.1.0
- **Changes:** Add GitHub Release automation, site zip backup, build-manifest artifact, rollback script, commit template.
- **Diff from v1.0.0:** infra only (workflow + tooling). Site content unchanged.
- **Rollback note:** Safe to roll back to v1.0.0 without content loss.

## v1.0.0 — 2026-04-22

- **Commit:** `00e2ed3`
- **Image:** `ghcr.io/shirazvaival/costsage-web:1.0.0`
- **Release:** https://github.com/shirazvaival/costsage-web/releases/tag/v1.0.0
- **Changes:** First tagged release. V2 homepage live (`index-v2.html` served at `/`).
- **Diff from v0.2:** nginx config change only; V1 `index.html` still reachable at `/index.html`.

## v0.2-v2-home — 2026-04-22

- **Commit:** `00e2ed3`
- **Image:** `ghcr.io/shirazvaival/costsage-web:sha-00e2ed3`
- **Changes:** nginx serves `index-v2.html` at root.
- **Diff from v0.1:** nginx.conf only.

## v0.1-rar-sync — 2026-04-22

- **Commit:** `79e9bdf`
- **Image:** `ghcr.io/shirazvaival/costsage-web:sha-79e9bdf`
- **Changes:** Synced `site/` from the canonical RAR build. 3 CTAs in `index-v2.html` now link to `pricing.html` (internal) instead of `app.costsage.ai`.
- **Diff from initial:** `site/index-v2.html` only.

## Initial — 2026-04-20

- **Commit:** `b171890`
- **Image:** `ghcr.io/shirazvaival/costsage-web:sha-b171890`
- **Changes:** Repo bootstrap. 15 HTML pages + assets + nginx Dockerfile + GHCR workflow.
