output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnets" {
  value = module.network.public_subnet_ids
}

output "ssh_sg_id" {
  value = module.network_security.ssh_sg_id
}

output "alb_dns" {
  value = module.application.alb_dns_name
}
