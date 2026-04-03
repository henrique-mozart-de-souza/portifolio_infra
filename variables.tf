# variables.tf (Raiz)

variable "aws_region" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "ID da Conta AWS"
  type        = string
  default     = "365916940374"
}

variable "project_name" {
  description = "Nome do Projeto"
  type        = string
  default     = "hms-cloud"
}

variable "ecr_repo_name" {
  description = "Nome do repositório no ECR"
  type        = string
  default     = "meu-portfolio"
}
