resource "aws_cloudfront_distribution" "cdn" {
  enabled = true

  origin {
    domain_name = var.bucket_domain
    origin_id   = "s3-origin"
  }

  default_cache_behavior {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
