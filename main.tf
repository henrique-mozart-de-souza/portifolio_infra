provider "aws" {
  region = var.aws_region
}

# 1. Camada de Rede
module "network" {
  source      = "./modules/network"
  environment = terraform.workspace
}

# 2. Camada de Segurança (Firewall e Roles)
module "security" {
  source      = "./modules/security"
  vpc_id      = module.network.vpc_id
  environment = terraform.workspace
}

# 3. Camada de Computação (O "Corpo" para o ECS)
module "compute" {
  source               = "./modules/compute"
  subnet_id            = module.network.public_subnet_id
  security_group       = module.security.web_sg_id
  iam_instance_profile = module.security.ecs_instance_profile_name # <-- A nova linha!
  environment          = terraform.workspace
  cluster_name         = module.ecs.cluster_name 
}

# 4. Camada de Orquestração (O "Cérebro")
module "ecs" {
  source        = "./modules/ecs"
  environment   = terraform.workspace
  ecr_image_url = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecr_repo_name}:latest"
}