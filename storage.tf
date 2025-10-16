resource "aws_s3_bucket" "cmtr_bucket" {
  bucket = "cmtr-d8cbjg27-bucket-1760650184"

  tags = {
    Project = "cmtr-d8cbjg27"
  }
}

# Bloquea el acceso público (mantiene bucket privado sin usar ACLs)
resource "aws_s3_bucket_public_access_block" "cmtr_block" {
  bucket                  = aws_s3_bucket.cmtr_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
