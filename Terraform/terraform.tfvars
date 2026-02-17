# General variables
project_name = "rds-iam-auth"
environment  = "dev"

# RDS variables
db_instance_class = "db.t3.micro"
db_storage_size   = 20
db_engine_version = "8.4.7"
db_engine         = "mysql"
db_storage_type   = "gp3"
db_name           = "node_db"
db_username       = "admin"
db_iam_auth_user  = "node_user"

# EC2 variables
app_port      = 3000
https_port    = 443
http_port     = "80"
instance_type = "t3.micro"
volume_size   = 10
volume_type   = "gp3"


# VPC variables
vpc_cidr      = "172.20.0.0/16"
default_route = "0.0.0.0/0"
publicip-01   = "129.222.205.51/32"
publicip-02   = "105.113.52.90/32"

# S3 variables
bucket_name = "rds-iam-auth-alb-logs"

# ALB variables
ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09"
domain_name       = "teachdev.online"
target_type       = "instance"
loadbalancer_type = "application"

