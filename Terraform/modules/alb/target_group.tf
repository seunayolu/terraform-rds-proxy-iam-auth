resource "aws_lb_target_group" "main" {
  name        = "${var.project_name}-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 5
    protocol            = "HTTP"
    port                = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "main" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = var.instance_id
  port             = var.app_port
}