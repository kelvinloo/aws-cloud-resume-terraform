

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


/*

// Set S3 bucket to public to allow 
resource "aws_s3_bucket_public_access_block" "hosting_bucket_acl" {
  bucket                  = aws_s3_bucket.hosting_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}





// Generates a javascript file with the view count api url to be used with index.html
locals {
  api_url = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}/prod/count"
}

resource "local_file" "local_js" {
  content = "fetch('${local.api_url}').then(response => response.json()).then((data) => {document.getElementById('views').innerText = 'Views: ' + data})"
  filename = "javascript.js"
}

resource "aws_s3_object" "viewCountjs" {
  bucket = var.bucket_name
  key    = "javascript.js"
  source = "javascript.js"
  depends_on = [
    local_file.local_js
  ]
}


locals {
  content_types = {
    css  = "text/css"
    html = "text/html"
    js   = "application/javascript"
    json = "application/json"
    txt  = "text/plain"
    ico = "image/x-icon"
    pug = "text/html"
    scss = "text/css"
  }
}


// Upload items into S3 bucket from website folder



resource "aws_s3_object" "website_files" {
  for_each = fileset("website/", "**")

  bucket      = aws_s3_bucket.hosting_bucket.id
  key         = each.key
  source      = "website/${each.key}"
  source_hash = filemd5("website/${each.key}")
  content_type = lookup(local.content_types, element(split(".", each.value), length(split(".", each.value)) - 1), "text/plain")
  content_encoding = "utf-8"
  depends_on = [
    aws_cloudfront_distribution.s3_distribution
  ]
}

*/
resource "aws_s3_bucket_policy" "cdn-cf-policy" {
  bucket = aws_s3_bucket.hosting_bucket.id
  policy = data.aws_iam_policy_document.cdntos3.json
}

data "aws_iam_policy_document" "cdntos3" {
  statement {
    principals {
      type        = "*"
      identifiers = [aws_cloudfront_distribution.s3_distribution.id]
    }
    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.hosting_bucket.arn}/*"]
  }
}
