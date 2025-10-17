# Datos de las instancias (para obtener network interface ids)
data "aws_instance" "public_instance" {
  instance_id = var.public_instance_id
}

data "aws_instance" "private_instance" {
  instance_id = var.private_instance_id
}

# 1) SSH Security Group
resource "aws_security_group" "ssh_sg" {
  name        = "cmtr-d8cbjg27-ssh-sg"
  description = "SSH + ICMP access from allowed IP ranges"
  vpc_id      = var.vpc_id

  tags = {
    Project = var.project
  }
}

# Ingress rules for SSH SG
resource "aws_security_group_rule" "ssh_allow_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.ssh_sg.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ip_range
  description       = "Allow SSH from allowed_ip_range"
}

resource "aws_security_group_rule" "ssh_allow_icmp" {
  type              = "ingress"
  security_group_id = aws_security_group.ssh_sg.id
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = var.allowed_ip_range
  description       = "Allow ICMP from allowed_ip_range"
}

# 2) Public HTTP Security Group
resource "aws_security_group" "public_http_sg" {
  name        = "cmtr-d8cbjg27-public-http-sg"
  description = "Public HTTP (80) and ICMP from allowed ranges"
  vpc_id      = var.vpc_id

  tags = {
    Project = var.project
  }
}

resource "aws_security_group_rule" "public_allow_http" {
  type              = "ingress"
  security_group_id = aws_security_group.public_http_sg.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ip_range
  description       = "Allow HTTP (80) from allowed_ip_range"
}

resource "aws_security_group_rule" "public_allow_icmp" {
  type              = "ingress"
  security_group_id = aws_security_group.public_http_sg.id
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = var.allowed_ip_range
  description       = "Allow ICMP from allowed_ip_range"
}

# 3) Private HTTP Security Group (only accessible from Public HTTP SG)
resource "aws_security_group" "private_http_sg" {
  name        = "cmtr-d8cbjg27-private-http-sg"
  description = "Private HTTP (8080) accessible only from public HTTP security group"
  vpc_id      = var.vpc_id

  tags = {
    Project = var.project
  }
}

resource "aws_security_group_rule" "private_allow_http_from_public_sg" {
  type                     = "ingress"
  security_group_id        = aws_security_group.private_http_sg.id
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public_http_sg.id
  description              = "Allow HTTP 8080 from public HTTP SG"
}

resource "aws_security_group_rule" "private_allow_icmp_from_public_sg" {
  type                     = "ingress"
  security_group_id        = aws_security_group.private_http_sg.id
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  source_security_group_id = aws_security_group.public_http_sg.id
  description              = "Allow ICMP from public HTTP SG"
}

# Attach security groups to the public instance's primary network interface
resource "aws_network_interface_sg_attachment" "attach_public_ssh" {
  network_interface_id = data.aws_instance.public_instance.network_interface_id
  security_group_id    = aws_security_group.ssh_sg.id
}

resource "aws_network_interface_sg_attachment" "attach_public_http" {
  network_interface_id = data.aws_instance.public_instance.network_interface_id
  security_group_id    = aws_security_group.public_http_sg.id
}

# Attach security groups to the private instance's primary network interface
resource "aws_network_interface_sg_attachment" "attach_private_ssh" {
  network_interface_id = data.aws_instance.private_instance.network_interface_id
  security_group_id    = aws_security_group.ssh_sg.id
}

resource "aws_network_interface_sg_attachment" "attach_private_private_http" {
  network_interface_id = data.aws_instance.private_instance.network_interface_id
  security_group_id    = aws_security_group.private_http_sg.id
}
