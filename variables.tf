variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name tag of the pre-created VPC"
  type        = string
  default     = "cmtr-d8cbjg27-vpc"
}

variable "public_subnet_names" {
  description = "Names of the public subnets (two)"
  type        = list(string)
  default     = ["cmtr-d8cbjg27-public-subnet1", "cmtr-d8cbjg27-public-subnet2"]
}

variable "sg_ssh_name" {
  description = "Name tag of SSH security group"
  type        = string
  default     = "cmtr-d8cbjg27-sg-ssh"
}

variable "sg_http_name" {
  description = "Name tag of HTTP security group (for instances)"
  type        = string
  default     = "cmtr-d8cbjg27-sg-http"
}

variable "sg_lb_name" {
  description = "Name tag of Load Balancer security group"
  type        = string
  default     = "cmtr-d8cbjg27-sg-lb"
}

variable "blue_weight" {
  description = "The traffic weight for the Blue Target Group (percentage)."
  type        = number
  default     = 100
}

variable "green_weight" {
  description = "The traffic weight for the Green Target Group (percentage)."
  type        = number
  default     = 0
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "desired_capacity" {
  description = "Desired number of instances per ASG"
  type        = number
  default     = 2
}

variable "key_name" {
  description = "Optional EC2 key pair name for SSH (leave empty if none)"
  type        = string
  default     = ""
}
