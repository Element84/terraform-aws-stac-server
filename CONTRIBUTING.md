## Contributing

We would love for you to contribute! Follow the steps below to get started, and please read the [Code of Conduct](./CODE_OF_CONDUCT.md) prior to your first commit.

## Dev Environment Setup

**Prerequisites**

- A VPC in an AWS account which contains at least one private subnet

**Setup**

- Clone this repository
- Install [tfenv](https://github.com/tfutils/tfenv)
- Install Terraform: `tfenv install` (note that this will install the specific version noted in .terraform-version)
- Initialize Terraform: `terraform init`
- Install [pre-commit](https://github.com/pre-commit/pre-commit)
- Install the pre-commit hooks: `pre-commit install`

**Getting Started**

At this point, you're ready to make some changes! When attempting to commit, pre-commit will ensure your changes pass our linting rules (and that READMEs are automatically updated via terraform-docs). For more detailed control of linting, doc generation etc. see the Optional Setup section below.

**Making a Change**

- Clone this repository, create a branch
- Make a great contribution!
- Validate and test your changes by deploying to AWS
- Add your change to [CHANGELOG.md](./CHANGELOG.md)
- Open a PR and fill out the PR template

**Useful Dev Commands**

```bash
# run all pre-commit checks
pre-commit run --all-files

# update READMEs via terraform-docs
pre-commit run terraform-docs-go --all-files

# tflint everything
pre-commit run terraform_tflint --all-files

# terraform format everything
terraform fmt --recursive
```

**Optional Setup**

- terraform-docs
  - Installing pre-commit enables you to `pre-commit run terraform-docs-go --all-files` to update documentation. For a little more control, directly install terraform-docs and use `terraform-docs .` at the root of this repo. For parity with our CICD tests, install the version of terraform-docs denoted in .pre-commit-config.yaml

## stac-server Version Support

stac-server is not packaged with this repository. The `stac_server_version` variable selects the version to deploy, and its release lambda dist ZIP is downloaded at apply time (see `utils/fetch-lambda-dist.bash`). When changing the version this module is tested against, update `stac_server_version` in `default.tfvars` and `utils/cicd/main.tf`, and note the change in CHANGELOG.md.

## Updating the historical-ingest Lambda

The historical-ingest module's `lambda.zip` is built from Python source in this repository and is committed. After changing `modules/historical-ingest/lambda/`, rebuild it with `./utils/build-historical-ingest.bash` and commit the result.
