resource "aws_s3_bucket" "cmtr_bucket" {
  bucket = "cmtr-d8cbjg27-bucket-1760650184"

  # Bloqueo de acceso público (recomendado en labs de seguridad)
  acl    = "private"

  tags = {
    Project = "cmtr-d8cbjg27"
  }
}
