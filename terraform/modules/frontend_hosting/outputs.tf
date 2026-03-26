output "bucket_name" {
  value = aws_s3_bucket.frontend.id
}

output "bucket_arn" {
  value = aws_s3_bucket.frontend.arn
}

output "bucket_domain_name" {
  value = aws_s3_bucket.frontend.bucket_regional_domain_name
}

output "cloudfront_id" {
  value = aws_cloudfront_distribution.cdn.id
}

output "cloudfront_arn" {
  value = aws_cloudfront_distribution.cdn.arn
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.cdn.domain_name
}
