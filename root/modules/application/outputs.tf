output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "asg_name" {
  value = aws_autoscaling_group.asg.name
}

output "target_group_arn" {
  value = aws_lb_target_group.app_tg.arn
}
