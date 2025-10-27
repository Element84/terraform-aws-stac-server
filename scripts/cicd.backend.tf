# tflint-ignore: terraform_required_version
terraform {
  backend "s3" {
    # these are injected from env vars by CICD
    bucket       = "TF_STATE_BUCKET"
    region       = "AWS_REGION"
    key          = "${GITHUB_REPOSITORY}-github-test.tfstate"
    use_lockfile = true
  }
}
