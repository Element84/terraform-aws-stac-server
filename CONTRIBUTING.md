## Contributing

We would love for you to contribute! Please follow the steps below to get started.

## Dev Environment Setup

**Prerequisites**

- An AWS account with an existing VPC, that contains at least one private subnet

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
- Add your change to CHANGELOG.md
- Open a PR and fill out the PR template

**Useful Dev Commands**

```bash
# run all pre-commit checks
pre-commit run --all-files

# update READMEs via terraform-docs
pre-commit run terraform-docs-go --all-files

# terraform-lint everything
pre-commit run terraform_tflint --all-files

# terraform format everything
terraform fmt --recursive
```

**Optional Setup**

- nvm
  - Needed if updating the default, built-in stac-server version
- terraform-docs
  - Installing pre-commit enables you to `pre-commit run terraform-docs-go --all-files` to update documentation. For a little more control, directly install terraform-docs and use `terraform-docs .` at the root of this repo. For parity with our CICD tests, install the version of terraform-docs denoted in .pre-commit-config.yaml

**Updating the Default, Built-In stac-server Version**

We package a specific stac-server version with each release of this repository. To change this packaged version:

1. Build stac-server and get its lambdas: `./utils/update-lambdas.bash v3.10.0`

2. *Important* -- follow the steps in `.github/pull_request_template.md` to note and propagate the change to appropriate files
