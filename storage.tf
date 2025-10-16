resource "aws_s3_bucket" "cmtr_bucket" {
  bucket = "cmtr-d8cbjg27-bucket-1760650184"

  tags = {
    Project = "cmtr-d8cbjg27"
  }
}

# Asignamos el ACL con el nuevo recurso
resource "aws_s3_bucket_acl" "cmtr_bucket_acl" {
  bucket = aws_s3_bucket.cmtr_bucket.id
  acl    = "private"
}
