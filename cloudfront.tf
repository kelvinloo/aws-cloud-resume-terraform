locals {
  s3_origin_id = var.domain_name
  api_gateway_id = "APIGATEWAY"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.hosting_bucket.bucket_regional_domain_name
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id

  }
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "dist/index.html"
  aliases = [var.domain_name]

  // S3
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.cert_acm_data.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
 
  origin {
    domain_name = "${aws_api_gateway_rest_api.view_count_api.id}.execute-api.${var.aws_region}.amazonaws.com"
    origin_id = "APIGATEWAY"
    custom_origin_config {
      http_port = "80"
      https_port = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
      custom_header {
      name = "x-api-key"
      value = "${aws_api_gateway_api_key.mykey.value}"
    }
  }

  // API Gateway
  ordered_cache_behavior {
    path_pattern     = "/prod/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.api_gateway_id
    viewer_protocol_policy = "https-only"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    cache_policy_id  = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
  }
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "oaccloudfront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

