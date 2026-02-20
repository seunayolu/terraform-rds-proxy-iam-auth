#
data "aws_region" "current" {}

locals {
  full_name   = module.rds.rds_secret_name
  secret_name = substr(local.full_name, 0, length(local.full_name) - 7)
}

resource "local_file" "rds_config" {
  filename = "${path.module}/rds.conf"
  content  = <<-EOT
    RDS_ENDPOINT="${module.rds.rds_address}"
    REGION="${data.aws_region.current.region}"
    MASTER_SECRET_NAME="${local.secret_name}"
    DB_NAME="${module.rds.rds_db_name}"
    IAM_ADMIN_USER="dbadmin"
  EOT
}