variable "name_prefix" {
  type    = string
  default = "cmtr-d8cbjg27"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "public_http_sg_id" {
  type = string
}

variable "private_http_sg_id" {
  type = string
}

variable "ssh_sg_id" {
  type = string
}

variable "ami_id" {
  type        = string
  description = "AMI ID to use for instances (must be valid in the selected region)."
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 2
}
