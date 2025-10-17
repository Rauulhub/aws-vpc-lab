variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}
variable "project_id" {
  description = "Project identifier for tagging"
  type        = string
}

variable "state_bucket" {
  description = "S3 bucket name for remote Terraform state"
  type        = string
}

variable "state_key" {
  description = "S3 key path for remote Terraform state file"
  type        = string
}
