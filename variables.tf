# -------------------------
# VARIABLES GLOBALES
# -------------------------

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for tagging and resource naming"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "ssh_key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name for EC2 instances"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket where instance startup script uploads file"
  type        = string
}

# -------------------------
# REDES Y SEGURIDAD
# -------------------------

variable "vpc_id" {
  description = "ID of the VPC where resources will be deployed"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs (for ALB)"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs (for Auto Scaling Group)"
  type        = list(string)
}

variable "ec2_sg_id" {
  description = "Security Group ID for EC2 SSH access"
  type        = string
}

variable "http_sg_id" {
  description = "Security Group ID for HTTP access to EC2 instances"
  type        = string
}

variable "alb_sg_id" {
  description = "Security Group ID for the Application Load Balancer"
  type        = string
}

# -------------------------
# AUTO SCALING CONFIG
# -------------------------

variable "asg_min_size" {
  description = "Minimum number of EC2 instances in Auto Scaling Group"
  type        = number
}

variable "asg_desired_size" {
  description = "Desired number of EC2 instances in Auto Scaling Group"
  type        = number
}

variable "asg_max_size" {
  description = "Maximum number of EC2 instances in Auto Scaling Group"
  type        = number
}
