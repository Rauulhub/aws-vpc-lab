resource "aws_instance" "cmtr_instance" {
  ami           = "ami-0e001c9271cf7f3b9" # Amazon Linux 2 en us-east-1
  instance_type = "t2.micro"

  subnet_id              = data.terraform_remote_state.base_infra.outputs.public_subnet_id
  vpc_security_group_ids = [data.terraform_remote_state.base_infra.outputs.security_group_id]

  tags = {
    Name      = "cmtr-instance"
    Terraform = "true"
    Project   = var.project_id
  }
}