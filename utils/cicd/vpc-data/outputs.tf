output "vpc_id" {
  value = data.aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = data.aws_vpc.vpc.cidr_block
}

output "private_subnet_ids" {
  value = values(data.aws_subnet.private_subnets)[*].id
}

output "security_group_id" {
  value = data.aws_security_group.security_group.id
}
