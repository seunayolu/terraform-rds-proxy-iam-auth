locals {
  rds_proxy_prx_id = element(split(":", aws_db_proxy.devdb_proxy.arn), 6)
  rds_secret_name  = element(split(":", aws_db_instance.main.master_user_secret[0].secret_arn), 6)
}