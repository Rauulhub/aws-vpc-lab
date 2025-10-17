resource "aws_launch_template" "lt" {
  name_prefix   = "${var.project_name}-template"
  image_id      = var.ami_id
  instance_type = "t3.micro"
  key_name      = var.ssh_key_name

  iam_instance_profile {
    name = "${var.project_name}-instance_profile"
  }

  vpc_security_group_ids = [
    "cmtr-d8cbjg27-ec2_sg",
    "cmtr-d8cbjg27-http_sg"
  ]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
  }

  user_data = base64encode(file("startup.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Terraform = "true"
      Project   = var.project_name
    }
  }

  tags = {
    Terraform = "true"
    Project   = var.project_name
  }
}
resource "aws_lb" "alb" {
  name               = "${var.project_name}-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["cmtr-d8cbjg27-sglb"]
  subnets            = ["subnet-XXXXX", "subnet-YYYYY"] # Usa los IDs de las subnets públicas

  tags = {
    Terraform = "true"
    Project   = var.project_name
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-xxxxxx" # ID real de tu VPC

  health_check {
    path = "/"
    port = "80"
  }

  tags = {
    Terraform = "true"
    Project   = var.project_name
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  tags = {
    Terraform = "true"
    Project   = var.project_name
  }
}
resource "aws_autoscaling_group" "asg" {
  name                = "${var.project_name}-asg"
  desired_capacity    = 2
  min_size            = 1
  max_size            = 2
  vpc_zone_identifier = ["subnet-XXXXX", "subnet-YYYYY"] # privadas recomendadas
  health_check_type   = "EC2"
  force_delete        = true

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tg.arn]

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn    = aws_lb_target_group.tg.arn
}
