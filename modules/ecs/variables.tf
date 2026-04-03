variable "environment" {
  description = "Ambiente (dev/prod)"
  type        = string
}

variable "ecr_image_url" {
  description = "URL completa da imagem no ECR"
  type        = string
}