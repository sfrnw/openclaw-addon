# Changelog

## [3.0.2] - 2026-02-19

### Fixed
- Added persistent storage with `volumes` (not `path`): `/data` → `/home/node/.openclaw`
- Added `hassio_api: true` for Supervisor access
- Config now persists between add-on restarts

## [3.0.1] - 2026-02-19

### Fixed
- Changed `gateway.bind` from `"0.0.0.0"` to `"lan"` (valid OpenClaw value)
- Telegram token now written directly to config file (not via CLI command)
- Config includes both gateway and channels sections on first run
- Updated startup message to show correct version (v3.0.1)

## [3.0.0] - 2026-02-19

### Complete Rewrite Based on Official Documentation

**Research:** Studied official OpenClaw Docker documentation at docs.openclaw.ai/install/docker

**Major Changes:**
- Complete rewrite based on official `docker-setup.sh` flow
- Uses official OpenClaw npm package (`npm install -g openclaw@latest`)
- Follows official Docker Compose structure
- Config stored at `/home/node/.openclaw/` (standard OpenClaw location)
- Gateway token auto-generated on first run
- Channels configured via CLI commands (official method)

**Fixed:**
- No more environment variable issues - uses standard OpenClaw config file
- Proper Node.js version (22-bookworm as per official docs)
- Correct user permissions (runs as `node` user, not root)
- Gateway bind to `0.0.0.0` for container accessibility
- Uses `--allow-unconfigured` flag as per official Docker flow

**Simplified:**
- Only `telegram_token` optional in config (all other config via Web UI)
- No complex schema - minimal configuration required
- Auto-generates gateway token on first run

**Technical:**
- Base image: `node:22-bookworm` (official runtime requirement)
- Config location: `/home/node/.openclaw/openclaw.json`
- Gateway port: 18789 (standard)
- Auth: Token-based (generated automatically)

---

## [2.0.5] and Earlier - Deprecated

All v1.x and v2.x versions are deprecated. Upgrade to v3.0.0 for official Docker flow.
