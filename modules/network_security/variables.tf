variable "vpc_id" {
  type = string
}

variable "allowed_ip_range" {
  type = list(string)
}

variable "name_prefix" {
  type    = string
  default = "cmtr-d8cbjg27"
}
