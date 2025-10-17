resource "aws_instance" "cmtr_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 en us-east-1
  instance_type = "t2.micro"

  subnet_id              = data.terraform_remote_state.base_infra.outputs.public_subnet_id
  vpc_security_group_ids = [data.terraform_remote_state.base_infra.outputs.security_group_id]

  tags = {
    Name      = "cmtr-instance"
    Terraform = "true"
    Project   = var.project_id
  }
}