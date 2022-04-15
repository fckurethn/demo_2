provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc/"
}

module "security_group" {
  source      = "./modules/security_group"
  vpc_id      = module.vpc.vpc_id
  environment = module.vpc.environment
}

module "alb" {
  source             = "./modules/alb"
  security_group_id  = module.security_group.security_group_id
  public_subnets_ids = module.vpc.public_subnets_ids
  vpc_id             = module.vpc.vpc_id
  instance_ids       = module.ec2.instance_ids
  amount             = module.ec2.amount
}

module "ec2" {
  source              = "./modules/ec2"
  vpc_id              = module.vpc.vpc_id
  security_group_id   = module.security_group.security_group_id
  public_subnets_ids  = module.vpc.public_subnets_ids
  private_subnets_ids = module.vpc.private_subnets_ids
}
