data "aws_acm_certificate" "issued" {
  domain   = "*.${data.aws_route53_zone.teachdev.name}"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "teachdev" {
  name         = var.domain_name
  private_zone = false
}