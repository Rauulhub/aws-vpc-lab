locals {
  lt_name  = "${var.name_prefix}-template"
  asg_name = "${var.name_prefix}-asg"
  lb_name  = "${var.name_prefix}-lb"
}

resource "aws_launch_template" "compute" {
  name_prefix   = local.lt_name
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [var.ssh_sg_id, var.private_http_sg_id]
  }

  user_data = file("${path.module}/user_data.tpl")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name_prefix}-instance"
    }
  }
}

resource "aws_lb" "app" {
  name               = local.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_http_sg_id]
  subnets            = var.subnet_ids
  tags = {
    Name = local.lb_name
  }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "${var.name_prefix}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path = "/"
    port = "80"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_autoscaling_group" "asg" {
  name                = local.asg_name
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.subnet_ids
  launch_template {
    id      = aws_launch_template.compute.id
    version = "$$Latest"
  }
  target_group_arns = [aws_lb_target_group.app_tg.arn]

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [
      load_balancers,
      target_group_arns,
    ]
  }

  # Optional: basic health checks; your environment might use ELB health checks instead
  health_check_type         = "ELB"
  health_check_grace_period = 300
}
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn    = aws_lb_target_group.app_tg.arn
}
