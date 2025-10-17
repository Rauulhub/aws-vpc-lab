# opcionales (si quieres controlar la región o tipo de instancia)
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.10.0.0/16"
}

variable "public_subnets" {
  description = "Map of public subnets"
  type = map(object({
    cidr = string
    az   = string
  }))
  default = {
    subnet_a = { cidr = "10.10.1.0/24", az = "us-east-1a" }
    subnet_b = { cidr = "10.10.3.0/24", az = "us-east-1b" }
    subnet_c = { cidr = "10.10.5.0/24", az = "us-east-1c" }
  }
}
