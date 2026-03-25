module "iam" {
  source = "../../modules/iam"
  project_name = var.project_name
}

module "dynamodb" {
  source = "../../modules/dynamodb"
  table_name = "${var.project_name}-table-${var.environment}"
}

module "lambda" {
  source = "../../modules/lambda"

  function_name = "${var.project_name}-lambda-${var.environment}"
  role_arn      = module.iam.lambda_role_arn
  table_name    = module.dynamodb.table_name
}

module "apigateway" {
  source = "../../modules/apigateway"

  lambda_arn        = module.lambda.lambda_arn
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
}

module "s3" {
  source = "../../modules/s3"

  bucket_name = "${var.project_name}-frontend-${var.environment}"
}

module "cloudfront" {
  source = "../../modules/cloudfront"

  bucket_domain = module.s3.bucket_domain_name
}
