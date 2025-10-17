variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnets" {
  description = "Map of public subnets with CIDR and AZ"
  type = map(object({
    cidr = string
    az   = string
  }))
  default = {
    a = { cidr = "10.10.1.0/24", az = "us-east-1a" }
    b = { cidr = "10.10.3.0/24", az = "us-east-1b" }
    c = { cidr = "10.10.5.0/24", az = "us-east-1c" }
  }
}

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}
