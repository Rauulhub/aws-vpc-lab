### ---------- Data lookups for pre-provisioned resources ----------
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = var.public_subnet_names
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

data "aws_security_group" "sg_ssh" {
  filter {
    name   = "group-name"
    values = [var.sg_ssh_name]
  }
}

data "aws_security_group" "sg_http" {
  filter {
    name   = "group-name"
    values = [var.sg_http_name]
  }
}

data "aws_security_group" "sg_lb" {
  filter {
    name   = "group-name"
    values = [var.sg_lb_name]
  }
}

### ---------- AMI (Amazon Linux 2) ----------
data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

### ---------- Application Load Balancer ----------
resource "aws_lb" "alb" {
  name               = "cmtr-d8cbjg27-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnets.public.ids
  security_groups    = [data.aws_security_group.sg_lb.id]

  tags = {
    Name  = "cmtr-d8cbjg27-lb"
    Env   = "lab-blue-green"
    Owner = "student"
  }
}

### ---------- Target Groups (Blue / Green) ----------
resource "aws_lb_target_group" "blue_tg" {
  name     = "cmtr-d8cbjg27-blue-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name = "cmtr-d8cbjg27-blue-tg"
    Env  = "blue"
  }
}

resource "aws_lb_target_group" "green_tg" {
  name     = "cmtr-d8cbjg27-green-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name = "cmtr-d8cbjg27-green-tg"
    Env  = "green"
  }
}

### ---------- Listener with weighted forward action ----------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.blue_tg.arn
        weight = var.blue_weight
      }

      target_group {
        arn    = aws_lb_target_group.green_tg.arn
        weight = var.green_weight
      }

      stickiness {
        enabled  = true
        duration = 300
      }
    }
  }
}

### ---------- Launch Templates ----------
resource "aws_launch_template" "blue" {
  name_prefix   = "cmtr-d8cbjg27-blue-template"
  image_id      = data.aws_ami.amazon_linux2.id
  instance_type = var.instance_type
  key_name      = var.key_name != "" ? var.key_name : null

  lifecycle {
    create_before_destroy = true
  }

  iam_instance_profile {
    # If needed, set instance profile name here. Left blank intentionally.
    # name = "your-iam-instance-profile"
  }

  user_data = base64encode(templatefile("${path.module}/start-blue.sh", {
    env_name = "Blue Environment"
  }))

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [data.aws_security_group.sg_http.id, data.aws_security_group.sg_ssh.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "cmtr-d8cbjg27-blue-instance"
      Env  = "blue"
    }
  }
}

resource "aws_launch_template" "green" {
  name_prefix   = "cmtr-d8cbjg27-green-template"
  image_id      = data.aws_ami.amazon_linux2.id
  instance_type = var.instance_type
  key_name      = var.key_name != "" ? var.key_name : null

  lifecycle {
    create_before_destroy = true
  }

  user_data = base64encode(templatefile("${path.module}/start-green.sh", {
    env_name = "Green Environment"
  }))

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [data.aws_security_group.sg_http.id, data.aws_security_group.sg_ssh.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "cmtr-d8cbjg27-green-instance"
      Env  = "green"
    }
  }
}

### ---------- Auto Scaling Groups ----------
resource "aws_autoscaling_group" "blue_asg" {
  name                = "cmtr-d8cbjg27-blue-asg"
  desired_capacity    = var.desired_capacity
  max_size            = var.desired_capacity
  min_size            = var.desired_capacity
  vpc_zone_identifier = data.aws_subnets.public.ids
  launch_template {
    id      = aws_launch_template.blue.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.blue_tg.arn]

  tag {
    key                 = "Name"
    value               = "cmtr-d8cbjg27-blue-asg-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Env"
    value               = "blue"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "green_asg" {
  name                = "cmtr-d8cbjg27-green-asg"
  desired_capacity    = var.desired_capacity
  max_size            = var.desired_capacity
  min_size            = var.desired_capacity
  vpc_zone_identifier = data.aws_subnets.public.ids
  launch_template {
    id      = aws_launch_template.green.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.green_tg.arn]

  tag {
    key                 = "Name"
    value               = "cmtr-d8cbjg27-green-asg-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Env"
    value               = "green"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

### ---------- Ensure ASGs register to TGs (optional attach resources) ----------
# Not required: aws_autoscaling automatically registers instances to the TGs when target_group_arns provided.

