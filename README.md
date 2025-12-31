# stac-server Terraform on AWS

An opinionated way of deploying [stac-server](https://github.com/stac-utils/stac-server) on AWS via Terraform. Commonly used in the [FilmDrop Ecosystem](https://github.com/Element84/filmdrop-aws-tf-modules), a suite of open source tools for ingesting, archiving, processing, analyzing and distributing geospatial data in the cloud.

**stac-server Version**

A default version of stac-server is packaged with this module. See the default value of `stac_server_version` in `inputs.tf` for the currently packaged version, and note that it can be overridden. Use caution when overriding the default version; we cannot guarantee the infrastructure deployed by this module will support versions of stac-server that it has not been tested with.

<!-- yes, newline required after <div> to separate html -->
<div align="center">

[![CI](https://github.com/Element84/terraform-aws-stac-server/actions/workflows/ci.yml/badge.svg)](https://github.com/Element84/terraform-aws-stac-server/actions/workflows/ci.yml)
[![Release Tests](https://github.com/Element84/terraform-aws-stac-server/actions/workflows/release-tests.yml/badge.svg)](https://github.com/Element84/terraform-aws-stac-server/actions/workflows/release-tests.yml)
[![Snyk Scan](https://github.com/Element84/terraform-aws-stac-server/actions/workflows/snyk-scan.yml/badge.svg)](https://github.com/Element84/terraform-aws-stac-server/actions/workflows/snyk-scan.yml)
[![GitHub Release](https://img.shields.io/github/v/release/Element84/terraform-aws-stac-server?color=2334D058)]()  [![License](https://img.shields.io/github/license/Element84/terraform-aws-stac-server?color=2334D058)]()

</div>


## General Usage

While this module is most commonly used in conjunction with a FilmDrop deployment, it can be deployed as a standalone STAC server. As a prerequisite, a VPC in an AWS account which contains at least one private subnet will be needed.

**Quickstart**

- Clone this repository
- Authenticate to the AWS account you're deploying to
- Install [tfenv](https://github.com/tfutils/tfenv), then use it to install Terraform: `tfenv install` 
  - This will install the specific Terraform version denoted in `.terraform-version`, which has been explicitly tested with this module. As an alternative to using tfenv, simply install that version of Terraform directly
- Optionally point to a remote Terraform state store, rather than storing state locally. See [/utils/cicd](./utils/cicd) for an S3 example
- Initialize Terraform: `terraform init`
- Edit `default.tfvars`, noting that some var values are invalid placeholders which must be updated
- You're now ready to validate/plan/apply, e.g. `terraform apply -var-file=default.tfvars`

**Example Usages:**

- [/utils/cicd](./utils/cicd) in this repository provides an example used by our CI/CD tests

- [filmdrop-aws-tf-modules](https://github.com/Element84/filmdrop-aws-tf-modules) is a complete working example usage in the core FilmDrop module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.5 |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_ingest_sqs_senders_arns"></a> [additional\_ingest\_sqs\_senders\_arns](#input\_additional\_ingest\_sqs\_senders\_arns) | List of additional principals to grant access to send to the Ingest SQS. This is required to allow STAC API SNS notifications (e.g. earth search's ingest SNS topic) to be able to publish SQS ingest messages to our stac-server for indexing. | `list(string)` | `[]` | no |
| <a name="input_allow_explicit_index"></a> [allow\_explicit\_index](#input\_allow\_explicit\_index) | Allow OpenSearch Explicit Index | `string` | `"true"` | no |
| <a name="input_api_lambda"></a> [api\_lambda](#input\_api\_lambda) | (optional, object) Parameters for the stac-server API Lambda function.<br/>  - zip\_filepath: (optional, string) Filepath to a ZIP that implements the<br/>    stac-server API Lambda. Path is relative to the root module of this<br/>    deployment. Overrides the default ZIP included with this module.<br/>  - runtime: (optional, string) Lambda runtime.<br/>  - handler: (optional, string) Lambda handler.<br/>  - memory\_mb: (optional, number) Lambda max memory (MB).<br/>  - timeout\_seconds (optional, number) Lambda timeout (seconds).<br/>  - environment\_variables: (optional, map(string)) Custom environment variables<br/>    to add to the Lambda. These will be merged with the default environment<br/>    variables. Custom variables with the same key will override defaults. | <pre>object({<br/>    zip_filepath          = optional(string)<br/>    runtime               = optional(string, "nodejs22.x")<br/>    handler               = optional(string, "index.handler")<br/>    memory_mb             = optional(number, 1024)<br/>    timeout_seconds       = optional(number, 30)<br/>    environment_variables = optional(map(string), {})<br/>  })</pre> | <pre>{<br/>  "environment_variables": {},<br/>  "handler": "index.handler",<br/>  "memory_mb": 1024,<br/>  "runtime": "nodejs22.x",<br/>  "timeout_seconds": 30,<br/>  "zip_filepath": null<br/>}</pre> | no |
| <a name="input_api_method_authorization_type"></a> [api\_method\_authorization\_type](#input\_api\_method\_authorization\_type) | STAC API Gateway method authorization type | `string` | `"NONE"` | no |
| <a name="input_api_rest_type"></a> [api\_rest\_type](#input\_api\_rest\_type) | STAC API Gateway type | `string` | `"EDGE"` | no |
| <a name="input_asset_proxy_bucket_list"></a> [asset\_proxy\_bucket\_list](#input\_asset\_proxy\_bucket\_list) | Comma-separated list of S3 bucket names to proxy. Required when `ASSET_PROXY_BUCKET_OPTION` is `LIST`.<br/><br/>Example: 'bucket1,bucket2,bucket3' | `string` | `""` | no |
| <a name="input_asset_proxy_bucket_option"></a> [asset\_proxy\_bucket\_option](#input\_asset\_proxy\_bucket\_option) | Control which S3 buckets are proxied through the API. See stac-server utils documentation for details.<br/><br/>Options: `NONE` (disabled), `ALL` (all S3 assets), `ALL_BUCKETS_IN_ACCOUNT` (all buckets in AWS account), `LIST` (specific buckets only). | `string` | `"NONE"` | no |
| <a name="input_asset_proxy_url_expiry"></a> [asset\_proxy\_url\_expiry](#input\_asset\_proxy\_url\_expiry) | Pre-signed URL expiry time in seconds for proxied assets. | `number` | `300` | no |
| <a name="input_authorized_s3_arns"></a> [authorized\_s3\_arns](#input\_authorized\_s3\_arns) | List of S3 bucket ARNs to give GetObject permissions to | `list(string)` | `[]` | no |
| <a name="input_collection_to_index_mappings"></a> [collection\_to\_index\_mappings](#input\_collection\_to\_index\_mappings) | A JSON object representing collection id to index name mappings if they do not have the same names | `string` | `""` | no |
| <a name="input_cors_credentials"></a> [cors\_credentials](#input\_cors\_credentials) | n/a | `bool` | `false` | no |
| <a name="input_cors_headers"></a> [cors\_headers](#input\_cors\_headers) | n/a | `string` | `""` | no |
| <a name="input_cors_methods"></a> [cors\_methods](#input\_cors\_methods) | n/a | `string` | `""` | no |
| <a name="input_cors_origin"></a> [cors\_origin](#input\_cors\_origin) | n/a | `string` | `"*"` | no |
| <a name="input_custom_vpce_id"></a> [custom\_vpce\_id](#input\_custom\_vpce\_id) | If you are managing a VPC Endpoint for API Gateways outside of this module, provide the VPC Endpoint ID here. <br/>This will prevent the module from creating a VPC Endpoint, and will use the provided one instead for<br/>configuring access to the private STAC Server API Gateway. If you have multiple API Gateways which need to<br/>communicate with VPC resources, they can share a central VPC Endpoint rather than creating one per API Gateway.<br/><br/>Should be used in conjunction with api\_rest\_type = "PRIVATE" | `string` | `null` | no |
| <a name="input_deploy_local_stac_server_artifacts"></a> [deploy\_local\_stac\_server\_artifacts](#input\_deploy\_local\_stac\_server\_artifacts) | Deploy STAC Server artifacts for local deploy | `bool` | `false` | no |
| <a name="input_deploy_stac_server_opensearch_serverless"></a> [deploy\_stac\_server\_opensearch\_serverless](#input\_deploy\_stac\_server\_opensearch\_serverless) | Deploy FilmDrop Stac-Server with OpenSearch Serverless. If False, Stac-server will be deployed with a classic OpenSearch domain. | `bool` | `false` | no |
| <a name="input_deploy_stac_server_outside_vpc"></a> [deploy\_stac\_server\_outside\_vpc](#input\_deploy\_stac\_server\_outside\_vpc) | Deploy FilmDrop Stac-Server resources, including OpenSearch outside VPC. Defaults to false. If False, Stac-server resources will be deployed within the vpc. | `bool` | `false` | no |
| <a name="input_domain_alias"></a> [domain\_alias](#input\_domain\_alias) | Custom domain alias for private API Gateway endpoint | `string` | `""` | no |
| <a name="input_enable_collections_authx"></a> [enable\_collections\_authx](#input\_enable\_collections\_authx) | Enable Collections Authx | `bool` | `false` | no |
| <a name="input_enable_filter_authx"></a> [enable\_filter\_authx](#input\_enable\_filter\_authx) | Enable Filter Authx | `bool` | `false` | no |
| <a name="input_enable_ingest_action_truncate"></a> [enable\_ingest\_action\_truncate](#input\_enable\_ingest\_action\_truncate) | Enable Ingest Action Truncate | `string` | `false` | no |
| <a name="input_enable_response_compression"></a> [enable\_response\_compression](#input\_enable\_response\_compression) | Enable Response Compression | `bool` | `false` | no |
| <a name="input_enable_transactions_extension"></a> [enable\_transactions\_extension](#input\_enable\_transactions\_extension) | Enable Transactions Extension | `bool` | `false` | no |
| <a name="input_ingest_lambda"></a> [ingest\_lambda](#input\_ingest\_lambda) | (optional, object) Parameters for the stac-server ingest Lambda function.<br/>  - zip\_filepath: (optional, string) Filepath to a ZIP that implements the<br/>    stac-server ingest Lambda. Path is relative to the root module of this<br/>    deployment. Overrides the default ZIP included with this module.<br/>  - runtime: (optional, string) Lambda runtime.<br/>  - handler: (optional, string) Lambda handler.<br/>  - memory\_mb: (optional, number) Lambda max memory (MB).<br/>  - timeout\_seconds (optional, number) Lambda timeout (seconds).<br/>  - environment\_variables: (optional, map(string)) Custom environment variables<br/>    to add to the Lambda. These will be merged with the default environment<br/>    variables. Custom variables with the same key will override defaults. | <pre>object({<br/>    zip_filepath          = optional(string)<br/>    runtime               = optional(string, "nodejs22.x")<br/>    handler               = optional(string, "index.handler")<br/>    memory_mb             = optional(number, 512)<br/>    timeout_seconds       = optional(number, 60)<br/>    environment_variables = optional(map(string), {})<br/>  })</pre> | <pre>{<br/>  "environment_variables": {},<br/>  "handler": "index.handler",<br/>  "memory_mb": 512,<br/>  "runtime": "nodejs22.x",<br/>  "timeout_seconds": 60,<br/>  "zip_filepath": null<br/>}</pre> | no |
| <a name="input_ingest_sns_topic_arns"></a> [ingest\_sns\_topic\_arns](#input\_ingest\_sns\_topic\_arns) | List of additional Ingest SNS topic arns to subscribe to stac server | `list(string)` | `[]` | no |
| <a name="input_ingest_sqs_dlq_timeout"></a> [ingest\_sqs\_dlq\_timeout](#input\_ingest\_sqs\_dlq\_timeout) | STAC Ingest SQS Dead Letter Queue Visibility Timeout | `number` | `30` | no |
| <a name="input_ingest_sqs_max_receive_count"></a> [ingest\_sqs\_max\_receive\_count](#input\_ingest\_sqs\_max\_receive\_count) | STAC Ingest SQS Max Receive Count | `number` | `2` | no |
| <a name="input_ingest_sqs_receive_wait_time_seconds"></a> [ingest\_sqs\_receive\_wait\_time\_seconds](#input\_ingest\_sqs\_receive\_wait\_time\_seconds) | STAC Ingest Receive Wait time | `number` | `5` | no |
| <a name="input_ingest_sqs_timeout"></a> [ingest\_sqs\_timeout](#input\_ingest\_sqs\_timeout) | STAC Ingest SQS Visibility Timeout | `number` | `120` | no |
| <a name="input_items_max_limit"></a> [items\_max\_limit](#input\_items\_max\_limit) | Items Max Limit | `number` | `100` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | Logging level (error, warn, info, http, verbose, debug, silly) | `string` | `"warn"` | no |
| <a name="input_opensearch_admin_username"></a> [opensearch\_admin\_username](#input\_opensearch\_admin\_username) | OpenSearch admin username | `string` | `"admin"` | no |
| <a name="input_opensearch_advanced_security_options_enabled"></a> [opensearch\_advanced\_security\_options\_enabled](#input\_opensearch\_advanced\_security\_options\_enabled) | OpenSearch advanced security options enabled | `bool` | `true` | no |
| <a name="input_opensearch_cluster_availability_zone_count"></a> [opensearch\_cluster\_availability\_zone\_count](#input\_opensearch\_cluster\_availability\_zone\_count) | OpenSearch Domain availability zone count | `number` | `3` | no |
| <a name="input_opensearch_cluster_dedicated_master_count"></a> [opensearch\_cluster\_dedicated\_master\_count](#input\_opensearch\_cluster\_dedicated\_master\_count) | Number of dedicated main nodes in the cluster. | `number` | `3` | no |
| <a name="input_opensearch_cluster_dedicated_master_enabled"></a> [opensearch\_cluster\_dedicated\_master\_enabled](#input\_opensearch\_cluster\_dedicated\_master\_enabled) | OpenSearch Domain dedicated master | `bool` | `false` | no |
| <a name="input_opensearch_cluster_dedicated_master_type"></a> [opensearch\_cluster\_dedicated\_master\_type](#input\_opensearch\_cluster\_dedicated\_master\_type) | OpenSearch Domain dedicated master instance type | `string` | `"m6g.large.search"` | no |
| <a name="input_opensearch_cluster_instance_count"></a> [opensearch\_cluster\_instance\_count](#input\_opensearch\_cluster\_instance\_count) | OpenSearch Domain instance count | `number` | `3` | no |
| <a name="input_opensearch_cluster_instance_type"></a> [opensearch\_cluster\_instance\_type](#input\_opensearch\_cluster\_instance\_type) | OpenSearch Domain instance type | `string` | `"c6g.large.search"` | no |
| <a name="input_opensearch_cluster_zone_awareness_enabled"></a> [opensearch\_cluster\_zone\_awareness\_enabled](#input\_opensearch\_cluster\_zone\_awareness\_enabled) | OpenSearch Domain zone awareness | `bool` | `true` | no |
| <a name="input_opensearch_domain_enforce_https"></a> [opensearch\_domain\_enforce\_https](#input\_opensearch\_domain\_enforce\_https) | OpenSearch Domain enforce https | `bool` | `true` | no |
| <a name="input_opensearch_domain_min_tls"></a> [opensearch\_domain\_min\_tls](#input\_opensearch\_domain\_min\_tls) | OpenSearch Domain minimum TLS | `string` | `"Policy-Min-TLS-1-2-2019-07"` | no |
| <a name="input_opensearch_ebs_volume_size"></a> [opensearch\_ebs\_volume\_size](#input\_opensearch\_ebs\_volume\_size) | OpenSearch EBS volume size | `number` | `35` | no |
| <a name="input_opensearch_ebs_volume_type"></a> [opensearch\_ebs\_volume\_type](#input\_opensearch\_ebs\_volume\_type) | OpenSearch EBS volume type | `string` | `"gp3"` | no |
| <a name="input_opensearch_host"></a> [opensearch\_host](#input\_opensearch\_host) | OpenSearch Host | `string` | `""` | no |
| <a name="input_opensearch_internal_user_database_enabled"></a> [opensearch\_internal\_user\_database\_enabled](#input\_opensearch\_internal\_user\_database\_enabled) | OpenSearch internal user database enabled | `bool` | `true` | no |
| <a name="input_opensearch_override_main_response_version"></a> [opensearch\_override\_main\_response\_version](#input\_opensearch\_override\_main\_response\_version) | Newer versions of Elasticsearch forcefully set this, even if it's not defined here in which case Terraform will try to<br/>revert it on every apply. This value does NOT actually change the setting in OpenSearch cluster. See the GitHub issue<br/>linked below. This value is here to appease Terraform only. If Terraform is nagging you with perpetual changes to<br/>override main response version, set this var to the value your cluster currently has or alternatively update your<br/>cluster settings via AWS API to match the default null value set by this module <br/>https://github.com/hashicorp/terraform-provider-aws/issues/27371<br/>https://docs.aws.amazon.com/opensearch-service/latest/APIReference/API_UpgradeDomain.html#opensearchservice-UpgradeDomain-request-AdvancedOptions | `string` | `null` | no |
| <a name="input_opensearch_stac_server_domain_name_override"></a> [opensearch\_stac\_server\_domain\_name\_override](#input\_opensearch\_stac\_server\_domain\_name\_override) | This optionally overrides the OpenSearch server name.  Since this name can't change after the server has been created, it is provided so that any changes to the default name don't require tearing down the server on future TF updates. | `string` | `null` | no |
| <a name="input_opensearch_stac_server_username"></a> [opensearch\_stac\_server\_username](#input\_opensearch\_stac\_server\_username) | OpenSearch stac server username | `string` | `"stac_server"` | no |
| <a name="input_opensearch_version"></a> [opensearch\_version](#input\_opensearch\_version) | OpenSearch version for OpenSearch Domain | `string` | `"OpenSearch_2.19"` | no |
| <a name="input_pre_hook_lambda"></a> [pre\_hook\_lambda](#input\_pre\_hook\_lambda) | (optional, object) Parameters for the stac-server pre-hook Lambda function.<br/>  - zip\_filepath: (optional, string) Filepath to a ZIP that implements the<br/>    stac-server auth pre-hook Lambda. Path is relative to the root module of<br/>    this deployment. Overrides the default ZIP included with this module.<br/>  - runtime: (optional, string) Lambda runtime.<br/>  - handler: (optional, string) Lambda handler.<br/>  - memory\_mb: (optional, number) Lambda max memory (MB).<br/>  - timeout\_seconds (optional, number) Lambda timeout (seconds).<br/>  - environment\_variables: (optional, map(string)) Custom environment variables<br/>    to add to the Lambda. These will be merged with the default environment<br/>    variables. Custom variables with the same key will override defaults. | <pre>object({<br/>    zip_filepath          = optional(string)<br/>    runtime               = optional(string, "nodejs22.x")<br/>    handler               = optional(string, "index.handler")<br/>    memory_mb             = optional(number, 128)<br/>    timeout_seconds       = optional(number, 25)<br/>    environment_variables = optional(map(string), {})<br/>  })</pre> | <pre>{<br/>  "environment_variables": {},<br/>  "handler": "index.handler",<br/>  "memory_mb": 128,<br/>  "runtime": "nodejs22.x",<br/>  "timeout_seconds": 25,<br/>  "zip_filepath": null<br/>}</pre> | no |
| <a name="input_private_api_additional_security_group_ids"></a> [private\_api\_additional\_security\_group\_ids](#input\_private\_api\_additional\_security\_group\_ids) | Optional list of security group IDs that'll be applied to the VPC interface<br/>endpoints of a PRIVATE-type stac-server API Gateway. These security groups are<br/>in addition to the security groups that allow traffic from the private subnet<br/>CIDR blocks. Only applicable when `var.api_rest_type == PRIVATE`. | `list(string)` | `null` | no |
| <a name="input_private_certificate_arn"></a> [private\_certificate\_arn](#input\_private\_certificate\_arn) | Private Certificate ARN for custom domain alias of private API Gateway endpoint | `string` | `""` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name | `string` | n/a | yes |
| <a name="input_request_logging_enabled"></a> [request\_logging\_enabled](#input\_request\_logging\_enabled) | Log all requests to the server | `bool` | `true` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | STAC ingest lambda reserved concurrent executions (max concurrency) | `number` | `10` | no |
| <a name="input_stac_api_rootpath"></a> [stac\_api\_rootpath](#input\_stac\_api\_rootpath) | If stac-server has a cloudfront distribution, this should be an empty string.<br/>If stac-server does not have a cloudfront distribution, the api\_rest\_type is<br/>PRIVATE, and you're managing a custom API Gateway domain outside of this module,<br/>this should be an empty string.<br/>If neither is true, the stac\_api\_stage var should be used. | `string` | `""` | no |
| <a name="input_stac_api_stage"></a> [stac\_api\_stage](#input\_stac\_api\_stage) | STAC API stage | `string` | `"dev"` | no |
| <a name="input_stac_api_stage_description"></a> [stac\_api\_stage\_description](#input\_stac\_api\_stage\_description) | STAC API stage description | `string` | `""` | no |
| <a name="input_stac_api_url"></a> [stac\_api\_url](#input\_stac\_api\_url) | When the STAC\_API\_URL env var is set, the item/message will have the self link set to the ingested items URL in the API; if not, the self link points to the copy of it in s3. | `string` | `""` | no |
| <a name="input_stac_description"></a> [stac\_description](#input\_stac\_description) | STAC description | `string` | `"A STAC API using stac-server"` | no |
| <a name="input_stac_docs_url"></a> [stac\_docs\_url](#input\_stac\_docs\_url) | STAC Documentation URL | `string` | `"https://stac-utils.github.io/stac-server/"` | no |
| <a name="input_stac_id"></a> [stac\_id](#input\_stac\_id) | STAC identifier | `string` | `"stac-server"` | no |
| <a name="input_stac_server_auth_pre_hook_enabled"></a> [stac\_server\_auth\_pre\_hook\_enabled](#input\_stac\_server\_auth\_pre\_hook\_enabled) | STAC API Pre-Hook Auth Lambda Enabled | `bool` | `false` | no |
| <a name="input_stac_server_post_hook_lambda_arn"></a> [stac\_server\_post\_hook\_lambda\_arn](#input\_stac\_server\_post\_hook\_lambda\_arn) | STAC API Post-Hook Lambda ARN | `string` | `""` | no |
| <a name="input_stac_server_pre_hook_lambda_arn"></a> [stac\_server\_pre\_hook\_lambda\_arn](#input\_stac\_server\_pre\_hook\_lambda\_arn) | STAC API Pre-Hook Lambda ARN | `string` | `""` | no |
| <a name="input_stac_server_version"></a> [stac\_server\_version](#input\_stac\_server\_version) | stac-server version. Leave this null to use the default, prepackaged version of stac-server.<br/><br/>If you need to use a custom version, set this variable to the desired version string *and* set<br/>deploy\_local\_stac\_server\_artifacts = true. Note though that custom versions of stac-server are not<br/>guaranteed to be compatible with this module. | `string` | `"v4.5.0"` | no |
| <a name="input_stac_title"></a> [stac\_title](#input\_stac\_title) | STAC title | `string` | `"STAC API"` | no |
| <a name="input_vpc_cidr_range"></a> [vpc\_cidr\_range](#input\_vpc\_cidr\_range) | CIDR Range for FilmDrop vpc | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | FilmDrop VPC ID | `string` | n/a | yes |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | List of security groups in the FilmDrop vpc | `list(string)` | n/a | yes |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | List of subnet ids in the FilmDrop vpc | `list(string)` | n/a | yes |
| <a name="input_vpce_private_dns_enabled"></a> [vpce\_private\_dns\_enabled](#input\_vpce\_private\_dns\_enabled) | Whether to enable Private DNS on the Interface VPC Endpoint used for the STAC API (execute-api). <br/>Leave false if you rely on VPC endpoint-specific hostnames; set true to resolve the standard API Gateway <br/>hostname to the VPC endpoint from within the VPC. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_stac_server_api_domain_name"></a> [stac\_server\_api\_domain\_name](#output\_stac\_server\_api\_domain\_name) | n/a |
| <a name="output_stac_server_api_gateway_id"></a> [stac\_server\_api\_gateway\_id](#output\_stac\_server\_api\_gateway\_id) | n/a |
| <a name="output_stac_server_api_lambda_arn"></a> [stac\_server\_api\_lambda\_arn](#output\_stac\_server\_api\_lambda\_arn) | n/a |
| <a name="output_stac_server_api_lambda_name"></a> [stac\_server\_api\_lambda\_name](#output\_stac\_server\_api\_lambda\_name) | n/a |
| <a name="output_stac_server_api_path"></a> [stac\_server\_api\_path](#output\_stac\_server\_api\_path) | n/a |
| <a name="output_stac_server_ingest_lambda_arn"></a> [stac\_server\_ingest\_lambda\_arn](#output\_stac\_server\_ingest\_lambda\_arn) | n/a |
| <a name="output_stac_server_ingest_lambda_name"></a> [stac\_server\_ingest\_lambda\_name](#output\_stac\_server\_ingest\_lambda\_name) | n/a |
| <a name="output_stac_server_ingest_queue_arn"></a> [stac\_server\_ingest\_queue\_arn](#output\_stac\_server\_ingest\_queue\_arn) | n/a |
| <a name="output_stac_server_ingest_queue_url"></a> [stac\_server\_ingest\_queue\_url](#output\_stac\_server\_ingest\_queue\_url) | n/a |
| <a name="output_stac_server_ingest_sns_topic_arn"></a> [stac\_server\_ingest\_sns\_topic\_arn](#output\_stac\_server\_ingest\_sns\_topic\_arn) | n/a |
| <a name="output_stac_server_lambda_iam_role_arn"></a> [stac\_server\_lambda\_iam\_role\_arn](#output\_stac\_server\_lambda\_iam\_role\_arn) | n/a |
| <a name="output_stac_server_name_prefix"></a> [stac\_server\_name\_prefix](#output\_stac\_server\_name\_prefix) | n/a |
| <a name="output_stac_server_opensearch_domain"></a> [stac\_server\_opensearch\_domain](#output\_stac\_server\_opensearch\_domain) | n/a |
| <a name="output_stac_server_opensearch_endpoint"></a> [stac\_server\_opensearch\_endpoint](#output\_stac\_server\_opensearch\_endpoint) | n/a |
| <a name="output_stac_server_opensearch_name"></a> [stac\_server\_opensearch\_name](#output\_stac\_server\_opensearch\_name) | n/a |
| <a name="output_stac_server_post_ingest_sns_topic_arn"></a> [stac\_server\_post\_ingest\_sns\_topic\_arn](#output\_stac\_server\_post\_ingest\_sns\_topic\_arn) | n/a |
<!-- END_TF_DOCS -->
