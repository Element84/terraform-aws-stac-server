# tflint-ignore: terraform_required_version
terraform {
  backend "s3" {
    # these are injected from environment variables by CICD
    bucket       = secrets.TF_STATE_BUCKET
    region       = secrets.AWS_REGION
    key          = "${REPOSITORY_NAME}-github-test.tfstate"
    use_lockfile = true
  }
}
