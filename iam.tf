# 🔹 Variable para el bucket
locals {
  bucket_name = "cmtr-d8cbjg27-bucket-1760652952"
  project_tag = "cmtr-d8cbjg27"
}

# 🔹 1. Crear IAM Group
resource "aws_iam_group" "cmtr_group" {
  name = "${local.project_tag}-iam-group"
}

# 🔹 2. Crear IAM Policy desde templatefile()
resource "aws_iam_policy" "cmtr_policy" {
  name        = "${local.project_tag}-iam-policy"
  description = "Custom policy to allow write access to S3 bucket"
  policy      = templatefile("${path.module}/policy.json", { bucket_name = local.bucket_name })

  tags = {
    Project = local.project_tag
  }
}

# 🔹 3. Crear IAM Role (EC2 assume role)
resource "aws_iam_role" "cmtr_role" {
  name = "${local.project_tag}-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Project = local.project_tag
  }
}

# 🔹 4. Adjuntar la policy al role
resource "aws_iam_role_policy_attachment" "cmtr_policy_attachment" {
  role       = aws_iam_role.cmtr_role.name
  policy_arn = aws_iam_policy.cmtr_policy.arn
}

# 🔹 5. Crear Instance Profile asociado al role
resource "aws_iam_instance_profile" "cmtr_instance_profile" {
  name = "${local.project_tag}-iam-instance-profile"
  role = aws_iam_role.cmtr_role.name

  tags = {
    Project = local.project_tag
  }
}
