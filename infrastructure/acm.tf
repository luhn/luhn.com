/* Provision an SSL certificate with AWS ACM. */

resource "aws_acm_certificate" "main" {
  provider          = "aws.east"
  domain_name       = "luhn.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "acm_validation" {
  name    = aws_acm_certificate.main.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.main.domain_validation_options[0].resource_record_type
  zone_id = aws_route53_zone.main.id
  records = [aws_acm_certificate.main.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "main" {
  provider                = "aws.east"
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [aws_route53_record.acm_validation.fqdn]
}

