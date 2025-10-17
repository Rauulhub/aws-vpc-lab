output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.cmtr_vpc.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.cmtr_vpc.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of all public subnets"
  value       = [for subnet in aws_subnet.cmtr_public_subnets : subnet.id]
}

output "public_subnet_cidr_block" {
  description = "CIDR blocks of public subnets"
  value       = [for subnet in aws_subnet.cmtr_public_subnets : subnet.cidr_block]
}

output "public_subnet_availability_zone" {
  description = "Availability zones of public subnets"
  value       = [for subnet in aws_subnet.cmtr_public_subnets : subnet.availability_zone]
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.cmtr_igw.id
}

output "routing_table_id" {
  description = "ID of the Route Table"
  value       = aws_route_table.cmtr_rt.id
}
