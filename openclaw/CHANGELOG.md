# Changelog

## [3.1.1] - 2026-02-21

### Fixed
- Dockerfile: Use official `ollama/ollama:latest` as base image (ARM64 only)
- Fixed build errors with Ollama installation
- Simplified build process

## [3.1.0] - 2026-02-21

### 🎉 MAJOR: Local AI with Ollama (No API Keys!)

**Added:**
- Ollama server integrated into add-on (runs locally)
- Pre-configured with `phi3:mini` (3.8B) model — best quality/speed balance
- Alternative models supported: `qwen2.5-coder:1.5b`, `qwen2.5-coder:3b`, `llama3.2:3b`
- No API keys required — completely free and private

**Changed:**
- Startup script now:
  1. Starts Ollama server in background
  2. Waits for Ollama to be ready
  3. Pulls model if not exists (~2GB, 5-10 min first time)
  4. Generates OpenClaw config with Ollama provider
  5. Starts OpenClaw gateway

**Config:**
- New option: `model` (default: `phi3:mini`)
- Ollama runs on port 11434 (exposed)
- OpenClaw connects to `http://localhost:11434/v1`

**Resource Usage:**
- Ollama server: ~200MB RAM
- phi3:mini model: ~2.5GB RAM
- OpenClaw: ~400MB RAM
- **Total: ~3.1GB** (works on Pi 5 with 8GB)

**Fixed:**
- No more OAuth issues with Qwen Portal
- No API key required
- Works completely offline after initial model download

### [3.0.6] - 2026-02-19

### Fixed
- Install Home Assistant CLI (`ha`) in container
- Bot can now execute HA commands without errors
- Required for full OpenClaw functionality in HA environment

## [3.0.5] - 2026-02-19

### Fixed
- Read Telegram token from `/data/options.json` (standard HA add-on pattern)
- Uses `jq` to parse options.json

## [3.0.4] - 2026-02-19

### Fixed
- Run container as root (not `node` user) to access `/data`
- HA add-on containers are sandboxed by HA, root is safe here

## [3.0.3] - 2026-02-19

### Fixed
- Use `map: ["data"]` (standard HA add-on pattern) instead of `volumes`
- Config stored at `/data/openclaw.json` (HA persistent storage)
- Symlink created for OpenClaw compatibility

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
