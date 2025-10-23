# Sets up artifacts for a local stac server deploy
resource "null_resource" "stac_server_local_artifact_setup" {
  count = var.deploy_local_stac_server_artifacts && var.stac_server_version != "" ? 1 : 0
  triggers = {
    stac_server_version = var.stac_server_version
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-ec"]
    command     = "./scripts/update-lambdas.bash ${var.stac_server_version}"
  }
}
