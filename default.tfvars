# project
project_name                             = "ssrv-cicd"
stac_id                                  = "stac-server"
stac_title                               = "STAC API"
stac_description                         = "A STAC API using stac-server"
stac_server_version                      = null
stac_api_stage                           = "git"
stac_api_rootpath                        = "git"
deploy_local_stac_server_artifacts       = false
deploy_stac_server_opensearch_serverless = true
deploy_stac_server_outside_vpc           = false

# NOTE: edit these VPC values with your AWS environment, the values below are placeholders
# vpc
vpc_id                 = "vpc-123456789"
vpc_cidr_range         = "10.0.0.0/16"
vpc_subnet_ids         = ["subnet-123456789"]
vpc_security_group_ids = ["sg-123456789"]

# and more!
enable_transactions_extension = false
enable_collections_authx      = false
enable_filter_authx           = false
enable_response_compression   = true
enable_ingest_action_truncate = false
# request_logging_enabled
# log_level
items_max_limit                             = 100
collection_to_index_mappings                = ""
opensearch_version                          = "OpenSearch_2.17"
opensearch_cluster_instance_type            = "t3.small.search"
opensearch_cluster_instance_count           = 3
opensearch_cluster_dedicated_master_enabled = true
opensearch_cluster_dedicated_master_type    = "t3.small.search"
opensearch_cluster_dedicated_master_count   = 3
opensearch_cluster_availability_zone_count  = 3
opensearch_cluster_zone_awareness_enabled   = true
opensearch_ebs_volume_size                  = 35
# opensearch_ebs_volume_size
# opensearch_domain_enforce_https
# opensearch_domain_min_tls
# opensearch_ebs_volume_type
# opensearch_host
# opensearch_advanced_security_options_enabled
# opensearch_internal_user_database_enabled
# opensearch_stac_server_username
# opensearch_stac_server_domain_name_override
# opensearch_admin_username
# allow_explicit_index
ingest_sns_topic_arns                     = []
additional_ingest_sqs_senders_arns        = []
api_rest_type                             = "EDGE"
api_method_authorization_type             = "NONE"
private_api_additional_security_group_ids = null

api_lambda = null
# example custom usage
# api_lambda = {
#   zip_filepath = "artifacts/stac-server/stac-server-v4.4.0-api-lambda-dist.zip"
#   runtime               = "nodejs22.x"
#   handler               = "index.handler"
#   memory_mb             = 1024
#   timeout_seconds       = 30
#   environment_variables = {
#     ENABLE_CONTEXT_EXTENSION = "true"
#     ENABLE_THUMBNAILS        = "true"
#   }
# }

ingest_lambda = null
# example custom usage
# ingest_lambda = {
#   zip_filepath = "artifacts/stac-server/stac-server-v4.4.0-ingest-lambda-dist.zip"
#   runtime               = "nodejs22.x"
#   handler               = "index.handler"
#   memory_mb             = 1024
#   timeout_seconds       = 30
#   environment_variables = {
#     ENABLE_CONTEXT_EXTENSION = "true"
#     ENABLE_THUMBNAILS        = "true"
#   }
# }

pre_hook_lambda = null
# example custom usage
# pre_hook_lambda = {
#   zip_filepath = "artifacts/stac-server/stac-server-v4.4.0-pre-hook-lambda-dist.zip"
#   runtime               = "nodejs22.x"
#   handler               = "index.handler"
#   memory_mb             = 1024
#   timeout_seconds       = 30
#   environment_variables = {
#     SOMEVAR = "true"
#   }
# }

authorized_s3_arns       = []
private_certificate_arn  = ""
vpce_private_dns_enabled = false
domain_alias             = ""
stac_api_url             = ""
# stac_docs_url
# stac_api_stage_description
cors_origin      = "*"
cors_credentials = false
cors_methods     = ""
cors_headers     = ""
# reserved_concurrent_executions 
# ingest_sqs_timeout
# ingest_sqs_max_receive_count
# ingest_sqs_receive_wait_time_seconds
# ingest_sqs_dlq_timeout
# stac_server_pre_hook_lambda_arn
# stac_server_auth_pre_hook_enabled
# stac_server_post_hook_lambda_arn
