resource "aws_cloudfront_distribution" "MyDistribution" {
  enabled             = true
  http_version        = "http1.1"
  wait_for_deployment = true
  is_ipv6_enabled     = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    viewer_protocol_policy = "allow-all"
    target_origin_id      = aws_s3_bucket.MyWebsite.bucket
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  origin {
    domain_name = aws_s3_bucket_website_configuration.example.website_endpoint
    origin_id   = aws_s3_bucket.MyWebsite.bucket

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["SSLv3"]
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.MyCertificate.arn
    ssl_support_method  = "sni-only"
  }

  aliases = [
    "www.rahulpatel.cloud",
    "aws.rahulpatel.cloud",
  ]

  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}