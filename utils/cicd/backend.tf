# tflint-ignore: terraform_required_version
terraform {
  backend "s3" {
    # these are injected from env vars by CICD
    bucket       = "VAR-TF_STATE_BUCKET"
    region       = "VAR-AWS_REGION"
    key          = "VAR-GITHUB_REPOSITORY-cicd-stac-server.tfstate"
    use_lockfile = true
  }
}
