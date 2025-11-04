# tflint-ignore: terraform_required_version
terraform {
  backend "s3" {
    # these are injected from env vars by CICD
    bucket       = "VAR-TF_STATE_BUCKET"
    region       = "VAR-AWS_REGION"
    key          = "stac-server-cicd-VAR-TF_STATE_FILENAME.tfstate"
    use_lockfile = true
  }
}
