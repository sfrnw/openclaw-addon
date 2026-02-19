# Changelog

## [2.0.0] - 2026-02-19

### Complete Rewrite

**Major Changes:**
- Complete rewrite of the add-on from scratch
- Fixed configuration loading from Home Assistant options.json
- Added proper validation for required fields
- Added jq for JSON parsing (more reliable than environment variables)

**Fixed:**
- Configuration now properly loads from `/data/options.json` (standard HA add-on pattern)
- Telegram token and gateway token are now correctly passed to OpenClaw
- Added validation to fail fast if required config is missing
- Removed reliance on environment variables (unreliable in HA add-ons)

**Added:**
- `jq` package for JSON parsing
- Detailed logging during startup
- Configuration validation with clear error messages
- Better error handling and user feedback

**Technical:**
- All documentation now in English
- Cleaner run.sh script with proper error handling
- Secure file permissions (700 for directories, 600 for config files)
- Standard Home Assistant add-on structure

---

## [1.0.5] - 2026-02-18

### Deprecated

This version and all v1.x versions are deprecated. Please upgrade to v2.0.0.

**Known Issues in v1.x:**
- Configuration not properly passed from Home Assistant UI
- Environment variables not working reliably
- Multiple schema compatibility issues

---

## [1.0.0] - 2026-02-18

### Added
- Initial release
- Home Assistant Add-on for OpenClaw AI Assistant
- Telegram integration
- Email support (Gmail via Himalaya)
- Web UI on port 18789
