resource "aws_acm_certificate" "cert_acm" {
  provider          = aws.acm
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_acm_certificate" "cert_acm_data" {
  domain   = var.domain_name
  provider = aws.acm
  depends_on = [
    aws_acm_certificate_validation.acm_validate
  ]
}

resource "aws_acm_certificate_validation" "acm_validate" {
  provider                = aws.acm
  certificate_arn         = aws_acm_certificate.cert_acm.arn
  validation_record_fqdns = [aws_route53_record.r53record.fqdn]
  depends_on = [
    aws_route53domains_registered_domain.registereddomain
  ]
}
