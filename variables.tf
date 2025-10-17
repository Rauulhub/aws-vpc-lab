# opcionales (si quieres controlar la región o tipo de instancia)
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "allowed_ip_range" {
  description = "Lista de rangos IP permitidos (CIDR). Ej: [\"18.153.146.156/32\",\"203.0.113.25/32\"]"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID del VPC provisto por la plataforma"
  type        = string
}

variable "public_subnet_id" {
  description = "ID del subnet público provisto por la plataforma"
  type        = string
}

variable "private_subnet_id" {
  description = "ID del subnet privado provisto por la plataforma"
  type        = string
}

variable "public_instance_id" {
  description = "ID de la instancia pública (ej: i-0b18bb948942be3ac)"
  type        = string
}

variable "private_instance_id" {
  description = "ID de la instancia privada (ej: i-046aa15449aae1cb5)"
  type        = string
}

variable "project" {
  description = "Tag Project para aplicar a los security groups"
  type        = string
  default     = "cmtr-d8cbjg27"
}
