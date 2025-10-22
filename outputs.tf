output "alb_dns_name" {
  description = "ALB DNS to access the service"
  value       = aws_lb.alb.dns_name
}

output "blue_target_group_arn" {
  value = aws_lb_target_group.blue_tg.arn
}

output "green_target_group_arn" {
  value = aws_lb_target_group.green_tg.arn
}
