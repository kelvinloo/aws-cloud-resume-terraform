

// Create S3 bucket
resource "aws_s3_bucket" "hosting_bucket" {
  bucket = var.bucket_name
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.hosting_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

// Set S3 bucket to public to allow 
resource "aws_s3_bucket_public_access_block" "hosting_bucket_acl" {
  bucket                  = aws_s3_bucket.hosting_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "cdn-cf-policy" {
  bucket = aws_s3_bucket.hosting_bucket.id
  policy = data.aws_iam_policy_document.cdntos3.json
}

data "aws_iam_policy_document" "cdntos3" {
  statement {
    principals {
      type        = "*"
      identifiers = [aws_cloudfront_distribution.s3_distribution.arn]
    }
    effect = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.hosting_bucket.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }

  }
}

