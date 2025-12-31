# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased

### Added

### Changed

### Fixed

### Removed



## [2.0.0] - 2025-12-31

### ⚠️ Breaking

**AWS Provider Upgrade v5 -> v6**

The Terraform AWS provider was updated from v5 to v6. A few deprecations in the `aws_api_gateway_deployment` resource necessitates the following (see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/version-6-upgrade#resource-aws_api_gateway_deployment). After pulling v2.x of this module:

- Update your `hashicorp/aws` provider to version constraint to "~> 6.0"

- `terraform init -upgrade`

- Run the following, replacing `<module_name>` and `<rest_api_id>`: `terraform import module.<module_name>.aws_api_gateway_stage.stac_server_api_gateway_stage <rest_api_id>/gh`

  - `<module_name>` is the name you've given this module in your root module; if you're not calling this module from another module, remove `module.<module_name>`. `<rest_api_id>` is the `stac_server_api_gateway_id` in outputs.tf

  - You'll see an "Import Successful" notification if your import works as expected

- `terraform apply`

Notes

- Terraform will note that a null_resource.enable_access_logs is being destroyed. This is expected. Previously, access logs were enabled via this null resource; with v2 of this module, they are enabled via the aws_api_gateway_stage resource.

**Updated the stac-server version this module packages `v3.10.0` -> `v4.5.0`**

- The minimum version of OpenSearch that [stac-server](https://github.com/stac-utils/stac-server) v4.5.0 expects is 2.19 (v3.10.0 expected 2.17). Accordingly, projects should update `opensearch_version` to `OpenSearch_2.19` at a minimum.

- Lambda runtimes should be bumped nodejs20 -> nodejs22

### Added

- A new custom_vpce_id var added. If provided, the user is indicating that they have an existing vpc endpoint that the titiler api gateway (and supporting resources) should allow to ingress

### Changed

- override_main_response_version input var added. Note that this does not actually change your OpenSearch cluster settings, see inputs.tf for details

- Four unused env vars were removed from the ingest lambda: `CORS_CREDENTIALS`, `CORS_HEADERS`, `CORS_METHODS`, `CORS_ORIGIN`

### Fixed

- Numerous readme and cicd chores

## [1.0.2] - 2025-11-03

### Added

- Finish release-tests cicd

## [1.0.1] - 2025-11-03

### Added

- Added support for custom environment variables in STAC Server Lambda functions (`api_lambda`, `ingest_lambda`,
`pre_hook_lambda`). Users can now pass custom environment variables via the optional `environment_variables`
parameter, enabling support for STAC Server v4.4.0+ features like `ENABLE_CONTEXT_EXTENSION` and
`ENABLE_THUMBNAILS`. This enhancement is fully backward compatible.

- Improved update-lambdas to ensure zips get built

### Changed

- Moved modules to a /modules folder

## [1.0.0] - 2025-10-30

### Added

- Support inputs.stac_server_version usage

- CICD setup

## [0.0.1] - 2025-10-23

### Added

- v3.10.0 of stac-server

- Initial version of this standalone stac-server infrastructure module
