resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = var.loadbalancer_type
  security_groups    = var.alb_security_groups
  subnets            = var.subnet_ids

  access_logs {
    bucket  = var.s3_alb_logs
    prefix  = "alb_access_logs"
    enabled = true
  }

  connection_logs {
    bucket  = var.s3_alb_logs
    prefix  = "alb_connection_logs"
    enabled = true
  }

  health_check_logs {
    bucket  = var.s3_alb_logs
    prefix  = "alb_health_check_logs"
    enabled = true
  }

  tags = {
    Name        = "${var.project_name}-alb"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.https_port
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = data.aws_acm_certificate.issued.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_listener" "redirect" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = var.https_port
      protocol    = "HTTPS"
      status_code = "HTTP_301"

    }
  }
}