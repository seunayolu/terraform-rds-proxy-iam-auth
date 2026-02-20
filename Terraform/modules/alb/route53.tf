resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.teachdev.zone_id
  name    = "app.${data.aws_route53_zone.teachdev.name}"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}