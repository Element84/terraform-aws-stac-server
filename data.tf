data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}

data "archive_file" "user_init_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/user_init"
  output_path = "${path.module}/user_init_lambda_zip.zip"
  depends_on = [
    random_string.user_init_lambda_zip_poke
  ]
}

data "archive_file" "waiting_for_opensearch_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/waiting_for_opensearch"
  output_path = "${path.module}/waiting_for_opensearch_lambda_zip.zip"
  depends_on = [
    random_string.user_init_lambda_zip_poke
  ]
}

data "aws_subnet" "selected" {
  count = length(var.vpc_subnet_ids)

  id = var.vpc_subnet_ids[count.index]
}

# this forces the user_init_lambda_zip to always be built
resource "random_string" "user_init_lambda_zip_poke" {
  length  = 16
  special = false
}

locals {
  name_prefix         = "fd-${var.project_name}-${coalesce(var.resource_name_suffix, var.stac_api_stage)}"
  opensearch_endpoint = var.deploy_stac_server_opensearch_serverless ? aws_opensearchserverless_collection.stac_server_opensearch_serverless_collection[0].collection_endpoint : aws_opensearch_domain.stac_server_opensearch_domain[0].endpoint
  opensearch_domain   = var.deploy_stac_server_opensearch_serverless ? aws_opensearchserverless_collection.stac_server_opensearch_serverless_collection[0].dashboard_endpoint : aws_opensearch_domain.stac_server_opensearch_domain[0].domain_name

  # Resolve the stac-server lambda dist ZIP filepath, used by the api, ingest, and pre-hook
  # lambdas. A user-provided filepath is expected to be relative to the root module. When
  # downloading, the version is included in the filename so a version change forces a lambda update.
  stac_server_dist_zip_filepath = (
    var.stac_server_lambda_zip_filepath != null
    ? "${path.root}/${var.stac_server_lambda_zip_filepath}"
    : "${path.root}/stac-server-lambda-dist-${var.stac_server_version}.zip"
  )

  # A user-provided ZIP is hashed so content changes force a lambda update. A downloaded ZIP does
  # not exist at plan time and cannot be hashed; the version-derived filename is the update trigger.
  stac_server_dist_zip_hash = (
    var.stac_server_lambda_zip_filepath != null
    ? filebase64sha256("${path.root}/${var.stac_server_lambda_zip_filepath}")
    : null
  )
}

# Download the stac-server lambda dist ZIP from the GitHub release matching stac_server_version,
# unless a local ZIP was provided. Re-download when the version changes.
resource "null_resource" "get_stac_server_lambda_dist" {
  count = var.stac_server_lambda_zip_filepath == null ? 1 : 0

  triggers = {
    stac_server_version = var.stac_server_version
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-ec"]
    command     = "'${path.module}/utils/fetch-lambda-dist.bash' '${var.stac_server_version}' '${local.stac_server_dist_zip_filepath}'"
  }
}
