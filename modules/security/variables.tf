variable "environment" {
  description = "Ambiente (ex: dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado"
  type        = string
}