# terraform.tfvars - reemplaza los valores por los tuyos

region       = "us-east-1"
ami_id       = "ami-09e6f87a47903347c"
ssh_key_name = "cmtr-d8cbjg27-keypair"
project_name = "cmtr-d8cbjg27"

# IDs de VPC / Subnets (usar los IDs reales de tu cuenta)
vpc_id = "vpc-0abcd1234efgh5678"

# Subnets públicas donde se colocará el ALB (2 subnets públicas en distintas AZs)
public_subnets = [
  "subnet-0aaaa1111aaaa1111",
  "subnet-0bbbb2222bbbb2222"
]

# Subnets privadas/privadas donde se lanzarán las instancias del ASG
private_subnets = [
  "subnet-0cccc3333cccc3333",
  "subnet-0dddd4444dddd4444"
]

# Security Group IDs (usar los SG ya provistos)
ec2_sg_id  = "sg-0ec2sg00000000001"  # cmtr-d8cbjg27-ec2_sg (SSH)
http_sg_id = "sg-0httpsg00000000002" # cmtr-d8cbjg27-http_sg (HTTP)
alb_sg_id  = "sg-0albs g00000000003" # cmtr-d8cbjg27-sglb (ALB)

# IAM instance profile name (pre-provisionado)
instance_profile_name = "cmtr-d8cbjg27-instance_profile"

# Nombre del bucket S3 donde las instancias subirán el archivo
s3_bucket_name = "cmtr-d8cbjg27-bucket"

# ASG sizing
asg_min_size     = 1
asg_desired_size = 2
asg_max_size     = 2
