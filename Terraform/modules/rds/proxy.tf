resource "aws_db_proxy" "devdb_proxy" {
  name                   = "dev-node-app"
  engine_family          = "MYSQL"
  require_tls            = true
  role_arn               = var.proxy_iam_role_arn
  vpc_security_group_ids = [var.proxy_security_group]
  vpc_subnet_ids         = var.subnet_ids

  default_auth_scheme = "IAM_AUTH"

  auth {
    iam_auth                  = "REQUIRED"
    secret_arn                = aws_db_instance.main.master_user_secret[0].secret_arn
    client_password_auth_type = "MYSQL_NATIVE_PASSWORD"
    description               = "End-to-end IAM auth without Secrets Manager"
  }

  lifecycle {
    ignore_changes = [auth]
  }
}

resource "aws_db_proxy_default_target_group" "main" {
  db_proxy_name = aws_db_proxy.devdb_proxy.name

  connection_pool_config {
    connection_borrow_timeout    = 120
    max_connections_percent      = 100
    max_idle_connections_percent = 50
  }
}

resource "aws_db_proxy_target" "main" {
  db_proxy_name          = aws_db_proxy.devdb_proxy.name
  target_group_name      = aws_db_proxy_default_target_group.main.name
  db_instance_identifier = aws_db_instance.main.identifier
}