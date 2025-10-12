variable "name_prefix" {
  description = "Prefijo/nombre base para recursos"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "Map of public subnets with AZ and CIDR"
  type = map(object({
    az   = string
    cidr = string
  }))
}
