/* Route53 zone */

resource "aws_route53_zone" "main" {
  name = "luhn.com"
}

resource "aws_route53_record" "main" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "luhn.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "ipv6" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "luhn.com"
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

/* DNS for email via Fastmail */

resource "aws_route53_record" "mx" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "luhn.com"
  type    = "MX"
  ttl     = 3600
  records = [
    "10 in1-smtp.messagingengine.com",
    "20 in2-smtp.messagingengine.com"
  ]
}

resource "aws_route53_record" "txt" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "luhn.com"
  type    = "TXT"
  ttl     = 3600
  records = ["v=spf1 include:spf.messagingengine.com ?all"]
}

resource "aws_route53_record" "dkim" {
  count   = 3
  zone_id = aws_route53_zone.main.zone_id
  name    = "fm${count.index + 1}._domainkey.luhn.com"
  type    = "CNAME"
  ttl     = 3600
  records = ["fm${count.index + 1}.luhn.com.dkim.fmhosted.com"]
}
