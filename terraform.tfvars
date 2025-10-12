name_prefix = "cmtr-d8cbjg27-01"
aws_region  = "us-east-1"
vpc_cidr    = "10.10.0.0/16"

public_subnets = {
  "public_a" = { az = "us-east-1a", cidr = "10.10.1.0/24" }
  "public_b" = { az = "us-east-1b", cidr = "10.10.3.0/24" }
  "public_c" = { az = "us-east-1c", cidr = "10.10.5.0/24" }
}
