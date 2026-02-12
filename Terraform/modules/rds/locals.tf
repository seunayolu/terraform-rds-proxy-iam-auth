locals {
  rds_proxy_prx_id = element(split(":", aws_db_proxy.devdb_proxy.arn), 6)
}