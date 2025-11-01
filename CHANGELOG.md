# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased

### Added

- Added support for custom environment variables in STAC Server Lambda functions (`api_lambda`, `ingest_lambda`,
`pre_hook_lambda`). Users can now pass custom environment variables via the optional `environment_variables`
parameter, enabling support for STAC Server v4.4.0+ features like `ENABLE_CONTEXT_EXTENSION` and
`ENABLE_THUMBNAILS`. This enhancement is fully backward compatible.

- Improved update-lambdas to ensure zips get built

### Changed

- Moved modules to a /modules folder

### Fixed

### Removed




## [1.0.0] - 2025-10-30

### Added

- Support inputs.stac_server_version usage

- CICD setup

## [0.0.1] - 2025-10-23

### Added

- v3.10.0 of stac-server

- Initial version of this standalone stac-server infrastructure module
