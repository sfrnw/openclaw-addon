# Changelog

## [1.0.5] - 2026-02-18

### Fixed
- Simplified Telegram config to minimal valid schema for v1.x
- Removed `allowlist` / `allowedUsers` (not valid keys in v1.x)
- Set `dmPolicy: pairing` (default, no allowlist needed)
- Removed unused config options: `timezone`, `telegram_allowed_users`, `notion_api_key`, `homeassistant_*`
- Added default value for `GATEWAY_TOKEN` if not provided

## [1.0.4] - 2026-02-18

### Fixed
- Fixed Telegram config format for OpenClaw v1.x
- Changed `channels.telegram.allowedUsers` → `channels.telegram.allowlist`
- Added `channels.telegram.enabled: true` and `dmPolicy: allowlist`
- Added `gateway.bind: loopback` and `gateway.auth.mode: token`
- Removed `defaults` section (not valid in v1.x schema)

## [1.0.3] - 2026-02-18

### Fixed
- Added `gateway.mode: local` to config (required for gateway start)
- Create required directories: `sessions`, `credentials`
- Set secure permissions: `~/.openclaw` (700), `openclaw.json` (600)
- Removed `openclaw doctor --fix` (not needed with correct config)

## [1.0.2] - 2026-02-18

### Fixed
- Updated config format to match OpenClaw v1.x schema
- Changed `gateway.token` → `gateway.auth.token`
- Removed deprecated `gateway.host` field
- Added `openclaw doctor --fix` to auto-migrate legacy configs

## [1.0.1] - 2026-02-18

### Fixed
- Fixed `run.sh` to use default config path (`/root/.openclaw/openclaw.json`) instead of `--config` flag
- Removed `--config` argument from `openclaw gateway start` command which caused startup failure

## [1.0.0] - 2026-02-18

### Added
- Initial release
- Home Assistant Add-on for OpenClaw AI Assistant
- Telegram integration
- Email support (Gmail via Himalaya)
- Home Assistant API integration (optional)
- Notion integration (optional)
- Web UI on port 18789
