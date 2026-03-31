terraform {
  backend "s3" {
    bucket       = "serverless-app-tfstate-010741811189"
    key          = "serverless/prod/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

module "iam" {
  source       = "../../modules/iam"
  project_name = var.project_name
  environment  = var.environment
  unique_suffix = var.unique_suffix
}

module "dynamodb" {
  source     = "../../modules/dynamodb"
  table_name = "${var.project_name}-table-${var.environment}-${var.unique_suffix}"
}

module "lambda" {
  source = "../../modules/lambda"

  function_name = "${var.project_name}-lambda-${var.environment}-${var.unique_suffix}"
  role_arn      = module.iam.lambda_role_arn
  table_name    = module.dynamodb.table_name
  environment   = var.environment
  app_name      = var.app_name
  cors_origins  = var.cors_origins
}

module "apigateway" {
  source = "../../modules/apigateway"

  lambda_arn        = module.lambda.lambda_arn
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
  project_name      = var.project_name
  environment       = var.environment

}

module "frontend_hosting" {
  source       = "../../modules/frontend_hosting"
  bucket_name  = "${var.project_name}-frontend-${var.environment}-${var.unique_suffix}"
  project_name = var.project_name
  environment  = var.environment
}
