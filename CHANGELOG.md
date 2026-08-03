# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased

### ⚠️ Breaking

**stac-server lambda ZIPs are now downloaded at apply time instead of committed to this module**

- Apply now requires `curl` and `jq` on the machine running Terraform, and network access to GitHub to fetch the [stac-server release](https://github.com/stac-utils/stac-server/releases) asset. Air-gapped or locked-down runners that planned successfully before will fail until the ZIP is provided another way.
- For local builds or stac-server versions without a release asset (prior to v5.0.0), set `stac_server_lambda_zip_filepath` to a local lambda dist ZIP to bypass the download.
- On the first apply after upgrading, the api, ingest, and pre-hook lambdas update in place (new ZIP filename, source hash, and handler). This is expected and non-destructive.

**`stac_server_version` is now a required input**

- Set `stac_server_version` to a release tag of the form `vX.Y.Z` (e.g. `v5.0.2`). Deployments that previously relied on a bundled version must now select one explicitly.

**Removed input variables**

- `deploy_local_stac_server_artifacts` and the `zip_filepath` field on `api_lambda` / `ingest_lambda` / `pre_hook_lambda` are gone. Remove any references; use `stac_server_lambda_zip_filepath` for a local ZIP instead.

### Added


- `stac_server_lambda_zip_filepath` variable for pointing at a local stac-server lambda dist ZIP instead of downloading a release asset
- `utils/fetch-lambda-dist.bash`, which downloads the lambda dist ZIP from a stac-server GitHub release (requires `curl` and `jq` at apply time)
- `utils/build-historical-ingest.bash`, which builds the historical-ingest module's `lambda.zip` (previously part of `utils/update-lambdas.bash`)

### Changed

- stac-server lambda ZIPs are no longer built and committed to this repository. The single lambda dist ZIP attached to [stac-server releases](https://github.com/stac-utils/stac-server/releases) (v5.0.0 and later) is downloaded at apply time and used by the api, ingest, and pre-hook lambdas. For older or custom stac-server versions, provide a ZIP via `stac_server_lambda_zip_filepath`. Existing deployments will see an in-place code and configuration update of these lambdas on the first apply after upgrading (new ZIP filename, source hash, and handler)
- `stac_server_version` is now required and selects the release to download
- Default `stac_server_version` is now `v5.0.2`
- Default lambda handlers changed to the dist ZIP entrypoints: `api/index.handler`, `ingest/index.handler`, and `pre-hook/index.handler`

### Fixed

### Removed

- `deploy_local_stac_server_artifacts` variable and the apply-time lambda build it triggered
- `zip_filepath` field from the `api_lambda`, `ingest_lambda`, and `pre_hook_lambda` variables; use `stac_server_lambda_zip_filepath` instead
- Committed lambda ZIPs (`lambda/api`, `lambda/ingest`, `lambda/pre-hook`) and `utils/update-lambdas.bash`

## [2.0.3] - 2026-01-27

### Fixed

- Correctly point API Gateway to the published lambda version so that features like provisioned concurrency work as expected, and trigger deployment of the gateway when any changes to dependencies occur

## [2.0.2] - 2026-01-26

### Added

- Lambda runtimes for the `user_init` and `historical_ingest` updated from python v3.9, which is beyond deprecation, to v3.10

- Enable OpenSearch logs via an optional input

## [2.0.1] - 2026-01-21

### Added

- Add capability to optionally use provisioned concurrency for the api lambda to avoid cold start issues.   Quantity can be set as input variable [48](https://github.com/Element84/terraform-aws-stac-server/pull/48)


## [2.0.0] - 2026-01-03

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
