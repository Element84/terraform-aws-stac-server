## Contributing

**Prerequisites**

- tfenv
- pre-commit
- nvm (if updating the default, built-in stac-server version)

**General Updates**

1. Install Terraform: `tfenv install`

2. Make a great contribution!

3. If you have `pre-commit` installed, tests should run at commit time. You can manually run tests via `pre-commit run --all-files`

4. Fill out the PR template

**Updating the Default, Built-In stac-server Version**

We prepackage a specific stac-server version with each release of this repository. To change this prepackaged version:

1. Build stac-server and get its lambdas: `./utils/update-lambdas.bash v3.10.0`

2. Follow the steps in the PR template to note and propagate the change to appropriate files
