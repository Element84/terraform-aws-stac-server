variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "stac_id" {
  description = "STAC identifier"
  type        = string
  default     = "stac-server"
  nullable    = false
}

variable "stac_title" {
  description = "STAC title"
  type        = string
  default     = "STAC API"
  nullable    = false
}

variable "stac_description" {
  description = "STAC description"
  type        = string
  default     = "A STAC API using stac-server"
  nullable    = false
}

variable "stac_server_version" {
  description = <<-DESCRIPTION
  (Optional) stac-server version to deploy, as a release tag of the form "vX.Y.Z". The default is the version this module release is tested against. The lambda dist ZIP for this version is downloaded from the [stac-server release](https://github.com/stac-utils/stac-server/releases) of the same tag, unless stac_server_lambda_zip_filepath is set. Releases prior to v5.0.0 do not include a lambda dist ZIP asset and require stac_server_lambda_zip_filepath. Not all stac-server versions are compatible with this module; versions other than the default have not been tested.
  DESCRIPTION

  type     = string
  nullable = false
  default  = "v5.0.2"

  validation {
    condition     = can(regex("^v\\d+\\.\\d+\\.\\d+", var.stac_server_version))
    error_message = "stac_server_version must be a tag of the form vX.Y.Z, e.g. v5.0.0."
  }
}

variable "stac_server_lambda_zip_filepath" {
  description = <<-DESCRIPTION
  (Optional) Filepath to a stac-server lambda dist ZIP, relative to the root module of this deployment. If set, this ZIP is used instead of downloading the release asset for stac_server_version. Use this for local stac-server builds (`npm run build-lambda-dist`) or for stac-server versions without a lambda dist ZIP release asset. The ZIP must contain all stac-server lambda entrypoints (api/index.js, ingest/index.js, pre-hook/index.js).
  DESCRIPTION

  type     = string
  nullable = true
  default  = null
}

variable "stac_api_stage" {
  description = "STAC API stage"
  type        = string
  default     = "dev"
}

variable "resource_name_suffix" {
  description = <<-DESCRIPTION
  (Optional) Suffix used with `fd-<project_name>-` to name all resources. Defaults to `stac_api_stage`. Set this to name resources independently of the API stage — e.g. serve the API at stage `v2` while resources stay named for the `dev` environment.
  DESCRIPTION

  type     = string
  nullable = true
  default  = null
}

variable "stac_api_provisioned_concurrency" {
  description = "Number of lambda instances to concurrently provision if desired for faster api response time and no cold start delay"
  type        = number
  default     = 0
}

variable "stac_api_rootpath" {
  description = <<-DESCRIPTION
  If stac-server has a cloudfront distribution, this should be an empty string. If stac-server does not have a cloudfront distribution, the api_rest_type is PRIVATE, and you're managing a custom API Gateway domain outside of this module, this should be an empty string. If neither is true, the stac_api_stage var should be used.
  DESCRIPTION
  type        = string
  default     = ""
}

variable "deploy_stac_server_opensearch_serverless" {
  type        = bool
  default     = false
  description = "Deploy FilmDrop Stac-Server with OpenSearch Serverless. If False, Stac-server will be deployed with a classic OpenSearch domain."
}

variable "deploy_stac_server_outside_vpc" {
  type        = bool
  default     = false
  description = "Deploy FilmDrop Stac-Server resources, including OpenSearch outside VPC. Defaults to false. If False, Stac-server resources will be deployed within the vpc."
}

variable "vpc_id" {
  description = "FilmDrop VPC ID"
  type        = string
}

variable "vpc_cidr_range" {
  description = "CIDR Range for FilmDrop vpc"
  type        = string
}

variable "vpc_subnet_ids" {
  description = "List of subnet ids in the FilmDrop vpc"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "List of security groups in the FilmDrop vpc"
  type        = list(string)
}

variable "enable_transactions_extension" {
  description = "Enable Transactions Extension"
  type        = bool
  default     = false
}

variable "enable_collections_authx" {
  description = "Enable Collections Authx"
  type        = bool
  default     = false
}

variable "enable_filter_authx" {
  description = "Enable Filter Authx"
  type        = bool
  default     = false
}

variable "enable_response_compression" {
  description = "Enable Response Compression"
  type        = bool
  default     = false
}

variable "enable_ingest_action_truncate" {
  description = "Enable Ingest Action Truncate"
  type        = string
  default     = false
}

variable "request_logging_enabled" {
  description = "Log all requests to the server"
  type        = bool
  default     = true
}

variable "log_level" {
  description = "Logging level (error, warn, info, http, verbose, debug, silly)"
  type        = string
  default     = "warn"
}

variable "items_max_limit" {
  description = "Items Max Limit"
  type        = number
  default     = 100
}

variable "collection_to_index_mappings" {
  description = "A JSON object representing collection id to index name mappings if they do not have the same names"
  type        = string
  default     = ""
}

variable "opensearch_version" {
  description = "OpenSearch version for OpenSearch Domain"
  type        = string
  default     = "OpenSearch_2.19"
}

variable "opensearch_cluster_instance_type" {
  description = <<-DESCRIPTION
  OpenSearch Domain instance type. Examples:
  - t3.small.search (entry level, development)
  - m6g.large.search (general purpose)
  - or2.medium.search (opensearch optimized)

  See AWS documentation for full list of supported instance types per region and engine version.
  DESCRIPTION
  type        = string
  default     = "c6g.large.search"
}

variable "opensearch_cluster_instance_count" {
  description = <<-DESCRIPTION
  The number of data nodes to provision in the OpenSearch cluster.

  Constraints:
  - If zone_awareness_enabled is false: Allowed values are integer >= 1.
  - If zone_awareness_enabled is true and availability_zone_count is 2: Must be an even number >= 2.
  - If zone_awareness_enabled is true and availability_zone_count is 3: Must be a multiple of 3 >= 3.
  DESCRIPTION
  type        = number
  default     = 3
}

variable "opensearch_cluster_zone_awareness_enabled" {
  description = <<-DESCRIPTION
  Enable Zone Awareness to distribute instances across multiple Availability Zones.

  Configuration Rules:
  - If true:
    - You must set opensearch_cluster_instance_count >= 2.
    - You must provided enough subnets in vpc_subnet_ids (at least availability_zone_count).
  - If false:
    - You can set opensearch_cluster_instance_count to 1 or more.
    - All instances will be placed in the first subnet provided in vpc_subnet_ids.
  DESCRIPTION
  type        = bool
  default     = true
  validation {
    condition     = var.opensearch_cluster_instance_count == 1 ? !var.opensearch_cluster_zone_awareness_enabled : true
    error_message = "If instance count is 1, zone awareness must be disabled."
  }
}

variable "opensearch_cluster_availability_zone_count" {
  description = <<-DESCRIPTION
  The number of Availability Zones to deploy the OpenSearch cluster across.

  Constraints:
  - Valid values are 2 or 3.
  - Only used and enforced when opensearch_cluster_zone_awareness_enabled is true.
  - You must provide at least this many subnets in vpc_subnet_ids.
  DESCRIPTION
  type        = number
  default     = 3
  validation {
    condition     = var.opensearch_cluster_zone_awareness_enabled ? contains([2, 3], var.opensearch_cluster_availability_zone_count) : true
    error_message = "If zone awareness is enabled, availability zone count must be 2 or 3."
  }
}

variable "opensearch_cluster_dedicated_master_enabled" {
  description = "OpenSearch Domain dedicated master"
  type        = bool
  default     = false
}

variable "opensearch_cluster_dedicated_master_type" {
  description = "OpenSearch Domain dedicated master instance type"
  type        = string
  default     = "m6g.large.search"
}

variable "opensearch_cluster_dedicated_master_count" {
  description = "Number of dedicated main nodes in the cluster."
  type        = number
  default     = 3
}

variable "opensearch_ebs_volume_size" {
  description = "OpenSearch EBS volume size"
  type        = number
  default     = 35
}

variable "opensearch_domain_enforce_https" {
  description = "OpenSearch Domain enforce https"
  type        = bool
  default     = true
}

variable "opensearch_domain_min_tls" {
  description = "OpenSearch Domain minimum TLS"
  type        = string
  default     = "Policy-Min-TLS-1-2-2019-07"
}

variable "opensearch_ebs_volume_type" {
  description = "OpenSearch EBS volume type"
  type        = string
  default     = "gp3"
}

variable "opensearch_override_main_response_version" {
  description = <<-DESCRIPTION
  Newer versions of Elasticsearch forcefully set this, even if it's not defined here in which case Terraform will try to revert it on every apply. This value does NOT actually change the setting in OpenSearch cluster. See the GitHub issue linked below. This value is here to appease Terraform only. If Terraform is nagging you with perpetual changes to override main response version, set this var to the value your cluster currently has or alternatively update your cluster settings via AWS API to match the default null value set by this module
  https://github.com/hashicorp/terraform-provider-aws/issues/27371
  https://docs.aws.amazon.com/opensearch-service/latest/APIReference/API_UpgradeDomain.html#opensearchservice-UpgradeDomain-request-AdvancedOptions
  DESCRIPTION
  type        = string
  default     = null
}

variable "opensearch_host" {
  description = "OpenSearch Host"
  type        = string
  default     = ""
}

variable "opensearch_advanced_security_options_enabled" {
  description = "OpenSearch advanced security options enabled"
  type        = bool
  default     = true
}

variable "opensearch_internal_user_database_enabled" {
  description = "OpenSearch internal user database enabled"
  type        = bool
  default     = true
}

variable "opensearch_stac_server_username" {
  description = "OpenSearch stac server username"
  type        = string
  default     = "stac_server"
}

variable "opensearch_stac_server_domain_name_override" {
  description = "This optionally overrides the OpenSearch server name.  Since this name can't change after the server has been created, it is provided so that any changes to the default name don't require tearing down the server on future TF updates."
  type        = string
  default     = null
}

variable "opensearch_admin_username" {
  description = "OpenSearch admin username"
  type        = string
  default     = "admin"
}

variable "allow_explicit_index" {
  description = "Allow OpenSearch Explicit Index"
  type        = string
  default     = "true"
}

variable "ingest_sns_topic_arns" {
  description = "List of additional Ingest SNS topic arns to subscribe to stac server"
  type        = list(string)
  default     = []
}

variable "additional_ingest_sqs_senders_arns" {
  description = "List of additional principals to grant access to send to the Ingest SQS. This is required to allow STAC API SNS notifications (e.g. earth search's ingest SNS topic) to be able to publish SQS ingest messages to our stac-server for indexing."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "api_rest_type" {
  description = "STAC API Gateway type"
  type        = string
  default     = "EDGE"
}

variable "api_method_authorization_type" {
  description = "STAC API Gateway method authorization type"
  type        = string
  default     = "NONE"

  validation {
    condition     = contains(["NONE", "CUSTOM", "AWS_IAM", "COGNITO_USER_POOLS"], var.api_method_authorization_type)
    error_message = "STAC API method authorization type must be one of: NONE, CUSTOM, AWS_IAM, or COGNITO_USER_POOLS."
  }
}

variable "private_api_additional_security_group_ids" {
  description = <<-DESCRIPTION
  Optional list of security group IDs that'll be applied to the VPC interface endpoints of a PRIVATE-type stac-server API Gateway. These security groups are in addition to the security groups that allow traffic from the private subnet CIDR blocks. Only applicable when `var.api_rest_type == PRIVATE`.
  DESCRIPTION
  type        = list(string)
  default     = null
}

variable "api_lambda" {
  description = <<-DESCRIPTION
  (optional, object) Parameters for the stac-server API Lambda function.
    - runtime: (optional, string) Lambda runtime.
    - handler: (optional, string) Lambda handler.
    - memory_mb: (optional, number) Lambda max memory (MB).
    - timeout_seconds (optional, number) Lambda timeout (seconds).
    - environment_variables: (optional, map(string)) Custom environment variables to add to the Lambda. These will be merged with the default environment variables. Custom variables with the same key will override defaults.
  DESCRIPTION

  type = object({
    runtime               = optional(string, "nodejs22.x")
    handler               = optional(string, "api/index.handler")
    memory_mb             = optional(number, 1024)
    timeout_seconds       = optional(number, 30)
    environment_variables = optional(map(string), {})
  })
  default = {
    runtime               = "nodejs22.x"
    handler               = "api/index.handler"
    memory_mb             = 1024
    timeout_seconds       = 30
    environment_variables = {}
  }
  nullable = false
}

variable "ingest_lambda" {
  description = <<-DESCRIPTION
  (optional, object) Parameters for the stac-server ingest Lambda function.
    - runtime: (optional, string) Lambda runtime.
    - handler: (optional, string) Lambda handler.
    - memory_mb: (optional, number) Lambda max memory (MB).
    - timeout_seconds (optional, number) Lambda timeout (seconds).
    - environment_variables: (optional, map(string)) Custom environment variables to add to the Lambda. These will be merged with the default environment variables. Custom variables with the same key will override defaults.
  DESCRIPTION

  type = object({
    runtime               = optional(string, "nodejs22.x")
    handler               = optional(string, "ingest/index.handler")
    memory_mb             = optional(number, 512)
    timeout_seconds       = optional(number, 60)
    environment_variables = optional(map(string), {})
  })
  default = {
    runtime               = "nodejs22.x"
    handler               = "ingest/index.handler"
    memory_mb             = 512
    timeout_seconds       = 60
    environment_variables = {}
  }
  nullable = false
}

variable "pre_hook_lambda" {
  description = <<-DESCRIPTION
  (optional, object) Parameters for the stac-server pre-hook Lambda function.
    - runtime: (optional, string) Lambda runtime.
    - handler: (optional, string) Lambda handler.
    - memory_mb: (optional, number) Lambda max memory (MB).
    - timeout_seconds (optional, number) Lambda timeout (seconds).
    - environment_variables: (optional, map(string)) Custom environment variables to add to the Lambda. These will be merged with the default environment variables. Custom variables with the same key will override defaults.
  DESCRIPTION

  type = object({
    runtime               = optional(string, "nodejs22.x")
    handler               = optional(string, "pre-hook/index.handler")
    memory_mb             = optional(number, 128)
    timeout_seconds       = optional(number, 25)
    environment_variables = optional(map(string), {})
  })
  default = {
    runtime               = "nodejs22.x"
    handler               = "pre-hook/index.handler"
    memory_mb             = 128
    timeout_seconds       = 25
    environment_variables = {}
  }
  nullable = false
}

variable "authorized_s3_arns" {
  description = "List of S3 bucket ARNs to give GetObject permissions to"
  type        = list(string)
  default     = []
}

variable "private_certificate_arn" {
  description = "Private Certificate ARN for custom domain alias of private API Gateway endpoint"
  type        = string
  default     = ""
}

variable "vpce_private_dns_enabled" {
  type        = bool
  default     = false
  description = <<-DESCRIPTION
  Whether to enable Private DNS on the Interface VPC Endpoint used for the STAC API (execute-api). Leave false if you rely on VPC endpoint-specific hostnames; set true to resolve the standard API Gateway hostname to the VPC endpoint from within the VPC.
  DESCRIPTION
}

variable "custom_vpce_id" {
  description = <<-DESCRIPTION
  If you are managing a VPC Endpoint for API Gateways outside of this module, provide the VPC Endpoint ID here. This will prevent the module from creating a VPC Endpoint, and will use the provided one instead for configuring access to the private STAC Server API Gateway. If you have multiple API Gateways which need to communicate with VPC resources, they can share a central VPC Endpoint rather than creating one per API Gateway.

  Should be used in conjunction with api_rest_type = "PRIVATE"
  DESCRIPTION

  type    = string
  default = null
}

variable "domain_alias" {
  description = "Custom domain alias for private API Gateway endpoint"
  type        = string
  default     = ""
}

variable "stac_api_url" {
  description = "When the STAC_API_URL env var is set, the item/message will have the self link set to the ingested items URL in the API; if not, the self link points to the copy of it in s3."
  type        = string
  default     = ""
}

variable "stac_docs_url" {
  description = "STAC Documentation URL"
  type        = string
  default     = "https://stac-utils.github.io/stac-server/"
}

variable "stac_api_stage_description" {
  description = "STAC API stage description"
  type        = string
  default     = ""
}

variable "cors_origin" {
  description = ""
  type        = string
  default     = "*"
}

variable "cors_credentials" {
  description = ""
  type        = bool
  default     = false
}

variable "cors_methods" {
  description = ""
  type        = string
  default     = ""
}

variable "cors_headers" {
  description = ""
  type        = string
  default     = ""
}

variable "reserved_concurrent_executions" {
  description = "STAC ingest lambda reserved concurrent executions (max concurrency)"
  type        = number
  default     = 10
}

variable "ingest_sqs_timeout" {
  description = "STAC Ingest SQS Visibility Timeout"
  type        = number
  default     = 120
}

variable "ingest_sqs_max_receive_count" {
  description = "STAC Ingest SQS Max Receive Count"
  type        = number
  default     = 2
}

variable "ingest_sqs_receive_wait_time_seconds" {
  description = "STAC Ingest Receive Wait time"
  type        = number
  default     = 5
}

variable "ingest_sqs_dlq_timeout" {
  description = "STAC Ingest SQS Dead Letter Queue Visibility Timeout"
  type        = number
  default     = 30
}

variable "stac_server_pre_hook_lambda_arn" {
  description = "STAC API Pre-Hook Lambda ARN"
  type        = string
  default     = ""
}

variable "stac_server_auth_pre_hook_enabled" {
  description = "STAC API Pre-Hook Auth Lambda Enabled"
  type        = bool
  default     = false
}

variable "stac_server_post_hook_lambda_arn" {
  description = "STAC API Post-Hook Lambda ARN"
  type        = string
  default     = ""
}

variable "asset_proxy_bucket_option" {
  description = <<-DESCRIPTION
  Control which S3 buckets are proxied through the API. See stac-server utils documentation for details.

  Options: `NONE` (disabled), `ALL` (all S3 assets), `ALL_BUCKETS_IN_ACCOUNT` (all buckets in AWS account), `LIST` (specific buckets only).
  DESCRIPTION

  type    = string
  default = "NONE"

  validation {
    condition     = contains(["NONE", "ALL", "ALL_BUCKETS_IN_ACCOUNT", "LIST"], var.asset_proxy_bucket_option)
    error_message = "asset_proxy_bucket_option must be one of NONE, ALL, ALL_BUCKETS_IN_ACCOUNT, LIST"
  }
}

variable "asset_proxy_bucket_list" {
  description = <<-DESCRIPTION
  Comma-separated list of S3 bucket names to proxy. Required when `ASSET_PROXY_BUCKET_OPTION` is `LIST`.

  Example: 'bucket1,bucket2,bucket3'
  DESCRIPTION

  type    = string
  default = ""
}

variable "asset_proxy_url_expiry" {
  description = <<-DESCRIPTION
  Pre-signed URL expiry time in seconds for proxied assets.
  DESCRIPTION

  type    = number
  default = 300
}

variable "opensearch_logs" {
  description = <<-EOT
    Configuration for OpenSearch log publishing to CloudWatch. This entire variable is optional. If not provided, no logs will be published.

    NOTE: This variable only applies to the managed (provisioned) OpenSearch service. It is NOT supported when `deploy_stac_server_opensearch_serverless` is set to `true`.

    You can configure any combination of the following log types (all are optional):
    - `ES_APPLICATION_LOGS`: OpenSearch application logs (error, warn, info).
    - `INDEX_SLOW_LOGS`: Logs for slow indexing operations.
    - `SEARCH_SLOW_LOGS`: Logs for slow search queries.
    - `AUDIT_LOGS`: Logs for access and security audits. Tracks user activity and access to the domain. Warning: Audit logs can be extremely verbose and may result in significant CloudWatch Log ingestion and storage costs.
  EOT
  type = object({
    ES_APPLICATION_LOGS = optional(object({
      enabled                     = bool
      retention_in_days           = number
      deletion_protection_enabled = optional(bool, false)
    }))
    INDEX_SLOW_LOGS = optional(object({
      enabled                     = bool
      retention_in_days           = number
      deletion_protection_enabled = optional(bool, false)
    }))
    SEARCH_SLOW_LOGS = optional(object({
      enabled                     = bool
      retention_in_days           = number
      deletion_protection_enabled = optional(bool, false)
    }))
    AUDIT_LOGS = optional(object({
      enabled                     = bool
      retention_in_days           = number
      deletion_protection_enabled = bool # required property; audit logs are usually very important
    }))
  })
  default = {}

  validation {
    condition     = var.deploy_stac_server_opensearch_serverless ? alltrue([for k, v in var.opensearch_logs : v == null]) : true
    error_message = "The `opensearch_logs` variable is not supported when `deploy_stac_server_opensearch_serverless` is true."
  }
}
