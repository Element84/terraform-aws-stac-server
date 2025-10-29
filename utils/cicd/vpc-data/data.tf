# For our CI/CD deployment of stac-server, we must pull VPC details of the AWS account that the CI/CD
# process is running in

locals {
  # A VPC with the following tag must exist in the AWS account used for CI/CD
  searchtag = {
    Name = "aws-controltower-VPC"
  }
}

data "aws_vpc" "vpc" {
  tags = local.searchtag
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  tags = local.searchtag
}

data "aws_subnet" "private_subnets" {
  for_each = toset(data.aws_subnets.private.ids)

  vpc_id = data.aws_vpc.vpc.id
  id     = each.value
}

data "aws_security_group" "security_group" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "group-name"
    values = ["default"]
  }
}
