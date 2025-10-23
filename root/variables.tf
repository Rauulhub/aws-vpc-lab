variable "region" {
  type        = string
  description = "AWS region where the resources will be deployed."
  default     = "us-east-1"
}

variable "name_prefix" {
  type        = string
  description = "Prefix used for naming all created AWS resources."
  default     = "cmtr-d8cbjg27"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.10.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones used for subnets."
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for the public subnets."
  default     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
}

variable "allowed_ip_range" {
  type        = list(string)
  description = "IP range allowed to access the instances via SSH."
  default     = ["0.0.0.0/0"]
}

variable "ami_id" {
  type        = string
  description = "AMI ID to use for EC2 instances."
}

variable "instance_type" {
  type        = string
  description = "Instance type for EC2 instances."
  default     = "t3.micro"
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of EC2 instances in the Auto Scaling Group."
  default     = 2
}

variable "min_size" {
  type        = number
  description = "Minimum number of EC2 instances in the Auto Scaling Group."
  default     = 2
}

variable "max_size" {
  type        = number
  description = "Maximum number of EC2 instances in the Auto Scaling Group."
  default     = 2
}
