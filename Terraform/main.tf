provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"

  project_name  = var.project_name
  environment   = var.environment
  default_route = var.default_route
  vpc_cidr      = var.vpc_cidr
  publicip-01   = var.publicip-01
  publicip-02   = var.publicip-02
}

module "security_group" {
  source = "./modules/security_group"

  project_name  = var.project_name
  prefix_list   = module.vpc.prefix_lists
  vpc_id        = module.vpc.vpc_id
  rds_port      = module.rds.rds_port
  app_port      = var.app_port
  https_port    = var.https_port
  http_port     = var.http_port
  default_route = var.default_route
}

module "rds" {
  source = "./modules/rds"

  project_name         = var.project_name
  environment          = var.environment
  db_engine            = var.db_engine
  db_engine_version    = var.db_engine_version
  db_instance_class    = var.db_instance_class
  db_name              = var.db_name
  db_username          = var.db_username
  db_storage_size      = var.db_storage_size
  db_storage_type      = var.db_storage_type
  subnet_ids           = module.vpc.private_subnet_ids
  proxy_security_group = module.security_group.rds_proxy_sg_id
  rds_security_group   = [module.security_group.rds_sg_id]
  proxy_iam_role_arn   = module.iam.rds_proxy_role_arn
  db_iam_auth_user     = var.db_iam_auth_user

}

module "iam" {
  source = "./modules/iam"

  project_name     = var.project_name
  environment      = var.environment
  rds_dbi          = module.rds.rds_dbi
  rds_proxy_prx_id = module.rds.rds_proxy_prx_id
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

# module "ec2" {
#   source = "./modules/ec2"

#   project_name         = var.project_name
#   environment          = var.environment
#   iam_instance_profile = module.iam.ec2_instance_profile_name
#   subnet_id            = module.vpc.private_subnet_ids[0]
#   security_group_ids   = [module.security_group.ec2_sg_id]
#   instance_type        = var.instance_type
#   volume_size          = var.volume_size
#   volume_type          = var.volume_type
# }

# module "s3" {
#   source = "./modules/s3"

#   project_name = var.project_name
#   environment  = var.environment
#   bucket_name  = var.bucket_name
# }

# module "alb" {
#   source = "./modules/alb"

#   project_name        = var.project_name
#   environment         = var.environment
#   vpc_id              = module.vpc.vpc_id
#   subnet_ids          = module.vpc.public_subnet_ids
#   alb_security_groups = [module.security_group.alb_sg_id]
#   target_type         = var.target_type
#   app_port            = var.app_port
#   https_port          = var.https_port
#   http_port           = var.http_port
#   ssl_policy          = var.ssl_policy
#   domain_name         = var.domain_name
#   s3_alb_logs         = module.s3.bucket_name
#   loadbalancer_type   = var.loadbalancer_type
#   instance_id         = module.ec2.instance_id

# }