# Encontrar el VPC por su tag Name = cmtr-d8cbjg27-vpc
data "aws_vpc" "cmtr_vpc" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-d8cbjg27-vpc"]
  }
}

# Obtener subnets del VPC (usaremos la primera disponible para el ejemplo)
data "aws_subnets" "cmtr_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.cmtr_vpc.id]
  }
}


# Buscar el security group por nombre dentro del VPC
data "aws_security_group" "cmtr_sg" {
  name   = "cmtr-d8cbjg27-sg"
  vpc_id = data.aws_vpc.cmtr_vpc.id
}

# Seleccionar AMI Amazon Linux 2 más reciente (propietario 'amazon')
data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "cmtr_d8cbjg27_ec2" {
  ami                    = data.aws_ami.amazon_linux2.id
  instance_type          = var.instance_type
  subnet_id              = element(data.aws_subnets.cmtr_subnets.ids, 0)
  vpc_security_group_ids = [data.aws_security_group.cmtr_sg.id]
  key_name               = aws_key_pair.cmtr_d8cbjg27_keypair.key_name

  tags = {
    Name    = "cmtr-d8cbjg27-ec2"
    Project = "epam-tf-lab"
    ID      = "cmtr-d8cbjg27"
  }

  # Optional: adjust block_device_mappings, user_data, etc. según necesites
}

# Outputs útiles
output "instance_id" {
  value = aws_instance.cmtr_d8cbjg27_ec2.id
}

output "instance_public_ip" {
  value = aws_instance.cmtr_d8cbjg27_ec2.public_ip
}

output "key_pair_name" {
  value = aws_key_pair.cmtr_d8cbjg27_keypair.key_name
}
