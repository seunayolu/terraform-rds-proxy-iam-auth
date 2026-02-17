output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.main.dns_name
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.main.arn
}

output "https_listener_arn" {
  description = "ARN of the listener"
  value       = aws_lb_listener.https.arn
}

output "http_listener_arn" {
  description = "ARN of the listener"
  value       = aws_lb_listener.redirect.arn
}