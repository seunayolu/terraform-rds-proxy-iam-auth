resource "aws_security_group" "rds_sg" {
  name        = "RDSSG"
  description = "RDS Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-RDSSG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_ingress_rule" {
  security_group_id = aws_security_group.rds_sg.id

  from_port                    = var.rds_port
  to_port                      = var.rds_port
  ip_protocol                  = "tcp"
  description                  = "Allow Incoming request on 3306 from RDS Proxy"
  referenced_security_group_id = aws_security_group.rds_proxy_sg.id
}

resource "aws_security_group" "rds_proxy_sg" {
  name        = "RDSPROXYSG"
  description = "RDS Proxy Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-RDSPROXYSG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_proxy_ingress_rule" {
  security_group_id = aws_security_group.rds_proxy_sg.id

  from_port                    = var.rds_port
  to_port                      = var.rds_port
  ip_protocol                  = "tcp"
  description                  = "Allow Incoming request on 3306 from EC2 Instance"
  referenced_security_group_id = aws_security_group.ec2_instance_sg.id
}

resource "aws_vpc_security_group_egress_rule" "proxy_to_rds" {
  security_group_id = aws_security_group.rds_proxy_sg.id

  from_port                    = var.rds_port
  to_port                      = var.rds_port
  ip_protocol                  = "tcp"
  description                  = "Allow Proxy to communicate with RDS"
  referenced_security_group_id = aws_security_group.rds_sg.id
}

resource "aws_security_group" "ec2_instance_sg" {
  name        = "EC2SG"
  description = "EC2 Instance Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-EC2SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_ingress_rule" {
  security_group_id = aws_security_group.ec2_instance_sg.id

  from_port      = var.app_port
  to_port        = var.app_port
  ip_protocol    = "tcp"
  description    = "Allow Incoming request on 3000 from my public IP"
  prefix_list_id = var.prefix_list
}

resource "aws_vpc_security_group_egress_rule" "ec2_egress_rule" {
  security_group_id = aws_security_group.ec2_instance_sg.id

  from_port                    = var.rds_port
  to_port                      = var.rds_port
  ip_protocol                  = "tcp"
  description                  = "Allow Outgoing traffic on 3306 to RDS Proxy"
  referenced_security_group_id = aws_security_group.rds_proxy_sg.id
}

resource "aws_vpc_security_group_egress_rule" "ec2_ssm_egress_rule" {
  security_group_id = aws_security_group.ec2_instance_sg.id

  from_port   = var.https_port
  to_port     = var.https_port
  ip_protocol = "tcp"
  description = "Allow Outgoing traffic on HTTPS (443) to SSM"
  cidr_ipv4   = var.default_route
}
