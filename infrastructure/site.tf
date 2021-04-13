/* Host the website on S3 fronted by CloudFront */

resource "aws_s3_bucket" "site" {
  bucket = "luhn.com"
}

resource "aws_s3_bucket_object" "index" {
  bucket       = aws_s3_bucket.site.id
  key          = "index.html"
  source       = "../index.html"
  etag         = filemd5("../index.html")
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "css" {
  bucket       = aws_s3_bucket.site.id
  key          = "main.css"
  source       = "../main.css"
  etag         = filemd5("../main.css")
  content_type = "text/css"
}

resource "aws_s3_bucket_object" "keybase" {
  bucket       = aws_s3_bucket.site.id
  key          = ".well-known/keybase.txt"
  source       = "../.well-known/keybase.txt"
  etag         = filemd5("../.well-known/keybase.txt")
  content_type = "text/plain"
}

/* Bucket permissions */

resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.site.iam_arn
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.site.arn}/*"
      },
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.site.iam_arn
        }
        Action   = "s3:ListBucket"
        Resource = aws_s3_bucket.site.arn
      },
    ]
  })
}

/* CloudFront */

resource "aws_cloudfront_distribution" "site" {
  enabled             = true
  aliases             = ["luhn.com"]
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100"
  wait_for_deployment = false

  origin {
    domain_name = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id   = "S3"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.site.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id       = "S3"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    default_ttl            = 365 * 60 * 60

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.main.arn
    minimum_protocol_version = "TLSv1.1_2016"
    ssl_support_method       = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "site" {}
