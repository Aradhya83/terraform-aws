data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)
}

module "vpc" {
  source = "./modules/vpc"

  name                 = var.project_name
  region               = var.aws_region
  vpc_cidr             = var.vpc_cidr
  azs                  = local.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}


module "security_groups" {
  source = "./modules/security_groups"

  name     = var.project_name
  vpc_id   = module.vpc.vpc_id
  app_port = var.app_port
  db_port  = var.db_port
}

