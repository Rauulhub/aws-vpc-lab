variable "ssh_key" {
  description = "Provides custom public SSH key."
  type        = string
  default     = ""
}

# opcionales (si quieres controlar la región o tipo de instancia)
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
