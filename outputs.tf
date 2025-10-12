output "vpc_id" {
  description = "VPC id created"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets (map)"
  value       = { for k, s in aws_subnet.public : k => s.id }
}

output "internet_gateway_id" {
  description = "Internet Gateway id"
  value       = aws_internet_gateway.igw.id
}

output "public_route_table_id" {
  description = "Public route table id"
  value       = aws_route_table.public_rt.id
}
