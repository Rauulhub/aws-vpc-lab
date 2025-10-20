resource "aws_instance" "cmtr_instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  subnet_id              = data.aws_subnet.public.id
  vpc_security_group_ids = [data.aws_security_group.selected.id]

  tags = {
    Name       = "${var.project_id}-instance"
    Project_ID = var.project_id
  }
}
