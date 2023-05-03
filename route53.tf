// Create Hosted zone on Route 53
resource "aws_route53_zone" "primary_hz" {
  name = var.domain_name
}

data "aws_route53_zone" "r53data" {
  name         = var.domain_name
  private_zone = false
  depends_on = [
    aws_route53_zone.primary_hz
  ]
}

resource "aws_route53_record" "r53record" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.cert_acm.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.cert_acm.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.cert_acm.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.r53data.id
  ttl             = 600
}

// Update names servers for domain name in order to force certificate validation
resource "aws_route53domains_registered_domain" "registereddomain" {
  domain_name   = var.registered_domain_name
  auto_renew    = false
  transfer_lock = false
  name_server {
    name = data.aws_route53_zone.r53data.name_servers[0]
  }
  name_server {
    name = data.aws_route53_zone.r53data.name_servers[1]
  }
  name_server {
    name = data.aws_route53_zone.r53data.name_servers[2]
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.r53data.id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
