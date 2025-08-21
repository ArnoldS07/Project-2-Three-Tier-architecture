locals { name = "${var.project}-${var.env}" }

module "vpc" {
  source   = "./modules/vpc"
  name     = local.name
  vpc_cidr = var.vpc_cidr
  azs      = var.azs
}

module "sg" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source            = "./modules/alb"
  name              = local.name
  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.vpc.public_subnet_ids
  alb_sg_id         = module.sg.alb_sg_id
}

module "iam" {
  source = "./modules/iam"
  name   = local.name
}

module "ec2" {
  source               = "./modules/ec2_asg"
  name                 = local.name
  region               = var.region
  private_app_subnets  = module.vpc.private_app_subnet_ids
  app_sg_id            = module.sg.app_sg_id
  alb_tg_arn           = module.alb.tg_arn
  instance_type        = var.ec2_instance_type
  desired_capacity     = var.desired_capacity
  iam_instance_profile = module.iam.instance_profile_name
  ecr_repo_frontend    = var.ecr_repo_frontend
  ecr_repo_backend     = var.ecr_repo_backend
  db_host              = module.rds.endpoint
  db_user              = var.db_username
  db_pass              = var.db_password
  db_port              = 5432
  key_name            = var.key_name  
}

module "rds" {
  source             = "./modules/rds"
  name               = local.name
  vpc_id             = module.vpc.vpc_id
  private_db_subnets = module.vpc.private_db_subnet_ids
  db_engine          = var.db_engine
  db_engine_version  = var.db_engine_version
  instance_class     = var.db_instance_class
  db_username        = var.db_username
  db_password        = var.db_password
  db_sg_source_id    = module.sg.app_sg_id
}

output "alb_dns_name" { value = module.alb.dns_name }
output "rds_endpoint" { value = module.rds.endpoint }
