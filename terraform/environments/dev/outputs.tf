output "api_gateway_url" {
  description = "API Gateway endpoint"
  value       = module.apigateway.api_endpoint
}

output "cloudfront_url" {
  description = "CloudFront distribution domain"
  value       = module.frontend_hosting.cloudfront_domain
}

output "s3_bucket_name" {
  description = "Frontend bucket"
  value       = module.frontend_hosting.bucket_name
}

output "lambda_function_name" {
  description = "Lambda function"
  value       = module.lambda.function_name
}

output "dynamodb_table_name" {
  description = "DynamoDB table"
  value       = module.dynamodb.table_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.frontend_hosting.cloudfront_id
}

output "frontend_url" {
  description = "Public frontend website URL"
  value       = "https://${module.frontend_hosting.cloudfront_domain}"
}
