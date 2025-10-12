# Crear el aws_key_pair usando la variable ssh_key (no almacenar pública en repo)
resource "aws_key_pair" "cmtr_d8cbjg27_keypair" {
  key_name   = "cmtr-d8cbjg27-keypair"
  public_key = var.ssh_key

  tags = {
    Project = "epam-tf-lab"
    ID      = "cmtr-d8cbjg27"
  }
}
