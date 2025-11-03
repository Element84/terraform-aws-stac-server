output "vpc_id" {
  value = data.aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = data.aws_vpc.vpc.cidr_block
}

output "private_subnet_ids" {
  value = data.aws_subnets.private.ids
}

output "security_group_id" {
  value = data.aws_security_group.security_group.id
}
