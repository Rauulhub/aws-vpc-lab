allowed_ip_range = ["18.153.146.156/32", "162.120.186.92/32"]
ami_id           = "ami-0c101f26f147fa7fd" # EJEMPLO: reemplaza por el AMI válido en us-east-1
public_subnet_cidrs = [
  "10.10.1.0/24", # subnet-public-a
  "10.10.3.0/24", # subnet-public-b
  "10.10.5.0/24"  # subnet-public-c
]

azs = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c"
]
