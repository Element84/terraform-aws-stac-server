output "vpc_id" {
  value = data.aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = data.aws_vpc.vpc.cidr_block
}