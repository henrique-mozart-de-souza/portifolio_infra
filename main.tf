module "network" {
  source       = "./modules/network"
  project_name = var.project_name
  environment  = var.environment
  vpcs         = var.vpcs
  subnets      = var.subnets
}

module "security" {
  source          = "./modules/security"
  project_name    = var.project_name
  environment     = var.environment
  vpc_ids         = module.network.vpc_ids
  security_groups = var.security_groups
}

module "compute" {
  source       = "./modules/compute"
  project_name = var.project_name
  environment  = var.environment
  subnet_ids   = module.network.subnet_ids
  sg_ids       = module.security.sg_ids
  instances    = var.instances
}