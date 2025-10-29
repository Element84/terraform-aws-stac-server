# stac-server Terraform on AWS

An opinionated way of deploying [stac-server](https://github.com/stac-utils/stac-server) on AWS.

<p align="center">
  <a href="https://github.com/Element84/terraform-aws-stac-server/actions?query=workflow%3AContinuous%20integration" target="_blank">
      <img src="https://github.com/Element84/terraform-aws-stac-server/workflows/Continuous%20integration/badge.svg" alt="Test">
  </a>
  <a href="https://github.com/Element84/terraform-aws-stac-server/actions?query=workflow%3ASnyk%20Scan" target="_blank">
      <img src="https://github.com/Element84/terraform-aws-stac-server/workflows/Snyk%20Scan/badge.svg" alt="Test">
  </a>
  <a href="https://github.com/Element84/terraform-aws-stac-server/releases" target="_blank">
      <img src="https://img.shields.io/github/v/release/Element84/terraform-aws-stac-server?color=2334D058" alt="Release version">
  </a>
  <a href="https://github.com/Element84/terraform-aws-stac-server/blob/main/LICENSE" target="_blank">
      <img src="https://img.shields.io/github/license/Element84/terraform-aws-stac-server?color=2334D058" alt="License">
  </a>
</p>

## Usage

While this module is most commonly used in conjunction with a FilmDrop deployment, it can be deployed as a standalone STAC server. As a prerequisite, a VPC in an AWS account which contains at least one private subnet will be needed.

Example usages:

- [filmdrop-aws-tf-modules](https://github.com/Element84/filmdrop-aws-tf-modules) is a complete working example usage in the core FilmDrop module

- `/utils/cicd` in this repository provides an example used in our CI/CD tests
