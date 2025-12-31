# CI/CD test deployment of stac-server. Note that we assume access to an AWS account which contains
# a VPC specifically tagged with { Name = "aws-controltower-VPC" } that contains the typical FilmDrop VPC
# setup with public/private subnets, networking, etc. See the main FilmDrop AWS Terraform modules 
# repository for more details.

# Query VPC details from the AWS account used for CI/CD
module "vpc-data" {
  source = "./vpc-data"
}

module "main" {
  source = "../.."

  # project
  project_name                             = "cicd"
  stac_id                                  = "stac-server"
  stac_title                               = "STAC API"
  stac_description                         = "A STAC API using stac-server"
  stac_server_version                      = null
  stac_api_stage                           = "gh"
  stac_api_rootpath                        = "gh"
  deploy_local_stac_server_artifacts       = false
  deploy_stac_server_opensearch_serverless = true
  deploy_stac_server_outside_vpc           = false

  # vpc
  vpc_id                 = module.vpc-data.vpc_id
  vpc_cidr_range         = module.vpc-data.vpc_cidr
  vpc_subnet_ids         = module.vpc-data.private_subnet_ids
  vpc_security_group_ids = [module.vpc-data.security_group_id]

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
  api_lambda                                = null
  ingest_lambda                             = null
  pre_hook_lambda                           = null
  authorized_s3_arns                        = []
  private_certificate_arn                   = ""
  vpce_private_dns_enabled                  = false
  custom_vpce_id                            = null
  domain_alias                              = ""
  stac_api_url                              = ""
  # stac_docs_url
  # stac_api_stage_description
  cors_origin               = "*"
  cors_credentials          = false
  cors_methods              = ""
  cors_headers              = ""
  asset_proxy_bucket_option = "NONE"
  asset_proxy_bucket_list   = ""
  asset_proxy_url_expiry    = 300
}
