# For our CI/CD deployment of stac-server, we must pull VPC details of the AWS account that the CI/CD
# process is running in

data "aws_vpc" "vpc" {
  tags = { Name = "aws-controltower-VPC" }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  tags = { Name = "aws-controltower-PrivateSubnet*" }
}

data "aws_security_group" "security_group" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "group-name"
    values = ["default"]
  }
}
