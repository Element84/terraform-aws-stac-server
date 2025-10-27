project_name                       = "terraform-aws-stac-server-cicd"
stac_api_stage                     = "git"
stac_server_version                = null
deploy_local_stac_server_artifacts = false
stac_id                            = "stac-server"
stac_title                         = "STAC API"
stac_description                   = "A STAC API using stac-server"

# TODO: query via data, or hardcode?
vpc_id                 = var.vpc_id
vpc_cidr_range         = var.vpc_cidr
vpc_subnet_ids         = var.private_subnet_ids
vpc_security_group_ids = [var.security_group_id]

enable_transactions_extension               = var.stac_server_inputs.enable_transactions_extension
enable_collections_authx                    = var.stac_server_inputs.enable_collections_authx
enable_filter_authx                         = var.stac_server_inputs.enable_filter_authx
enable_response_compression                 = var.stac_server_inputs.enable_response_compression
items_max_limit                             = var.stac_server_inputs.items_max_limit
enable_ingest_action_truncate               = var.stac_server_inputs.enable_ingest_action_truncate
collection_to_index_mappings                = var.stac_server_inputs.collection_to_index_mappings
opensearch_version                          = var.stac_server_inputs.opensearch_version
opensearch_cluster_instance_type            = var.stac_server_inputs.opensearch_cluster_instance_type
opensearch_cluster_instance_count           = var.stac_server_inputs.opensearch_cluster_instance_count
opensearch_cluster_dedicated_master_enabled = var.stac_server_inputs.opensearch_cluster_dedicated_master_enabled
opensearch_cluster_dedicated_master_type    = var.stac_server_inputs.opensearch_cluster_dedicated_master_type
opensearch_cluster_dedicated_master_count   = var.stac_server_inputs.opensearch_cluster_dedicated_master_count
opensearch_cluster_availability_zone_count  = var.stac_server_inputs.opensearch_cluster_availability_zone_count
opensearch_ebs_volume_size                  = var.stac_server_inputs.opensearch_ebs_volume_size
ingest_sns_topic_arns                       = var.stac_server_inputs.ingest_sns_topic_arns
additional_ingest_sqs_senders_arns          = var.stac_server_inputs.additional_ingest_sqs_senders_arns
api_rest_type                               = var.stac_server_inputs.api_rest_type
api_method_authorization_type               = var.stac_server_inputs.api_method_authorization_type
private_api_additional_security_group_ids   = var.stac_server_inputs.private_api_additional_security_group_ids
api_lambda                                  = var.stac_server_inputs.api_lambda
ingest_lambda                               = var.stac_server_inputs.ingest_lambda
pre_hook_lambda                             = var.stac_server_inputs.pre_hook_lambda
authorized_s3_arns                          = var.stac_server_inputs.authorized_s3_arns
deploy_stac_server_opensearch_serverless    = var.deploy_stac_server_opensearch_serverless
deploy_stac_server_outside_vpc              = var.deploy_stac_server_outside_vpc
private_certificate_arn                     = var.stac_server_inputs.private_certificate_arn
vpce_private_dns_enabled                    = var.stac_server_inputs.vpce_private_dns_enabled
domain_alias                                = var.stac_server_inputs.domain_alias

# CloudFront or a custom domain implies the rootpath is simply "/"
stac_api_rootpath = var.stac_server_inputs.deploy_cloudfront || var.stac_server_inputs.domain_alias != "" ? "" : "/${var.environment}"
stac_api_url      = var.stac_server_inputs.domain_alias != "" ? "https://${var.stac_server_inputs.domain_alias}" : ""

cors_origin      = var.stac_server_inputs.cors_origin
cors_credentials = var.stac_server_inputs.cors_credentials
cors_methods     = var.stac_server_inputs.cors_methods
cors_headers     = var.stac_server_inputs.cors_headers
