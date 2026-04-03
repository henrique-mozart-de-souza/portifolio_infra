terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket  = "hms-portifolio-infra"       # O nome exato do seu bucket
    key     = "infra/terraform.tfstate"    # O caminho/pasta onde o estado será salvo dentro do bucket
    region  = "us-east-1"                  # A região onde o bucket foi criado
    encrypt = true
    # dynamodb_table = "NOME_DA_SUA_TABELA" 
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

