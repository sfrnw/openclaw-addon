# Changelog

## [2.0.5] - 2026-02-19

### Fixed
- Removed incorrect PATH override (npm global bin is already in /usr/local/bin on Alpine)
- Added verification that openclaw binary exists before starting
- Added debug output for troubleshooting

## [2.0.4] - 2026-02-19

### Fixed
- Read config from environment variables (standard HA add-on pattern)

## [2.0.3] - 2026-02-19

### Fixed
- Removed build-time verification that caused Docker build to fail
- Simplified Dockerfile to absolute minimum

## [2.0.2] - 2026-02-19

### Fixed
- Added npm global bin to PATH (`/root/.npm-global/bin`)

## [2.0.1] - 2026-02-19

### Fixed
- Simplified Dockerfile to minimal dependencies
- Fixed run.sh to use `/bin/sh` instead of bash
- Removed complex error handling that caused issues
- Simplified config.json schema

## [2.0.0] - 2026-02-19

### Changed
- Complete rewrite with proper options.json loading
