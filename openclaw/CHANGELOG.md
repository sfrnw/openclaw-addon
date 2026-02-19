# Changelog

## [2.0.2] - 2026-02-19

### Fixed
- Added npm global bin to PATH (`/root/.npm-global/bin`)
- Added verification of openclaw installation in Dockerfile
- Added token preview in logs for debugging

## [2.0.1] - 2026-02-19

### Fixed
- Simplified Dockerfile to minimal dependencies
- Fixed run.sh to use `/bin/sh` instead of bash
- Removed complex error handling that caused issues
- Simplified config.json schema

## [2.0.0] - 2026-02-19

### Changed
- Complete rewrite with proper options.json loading
