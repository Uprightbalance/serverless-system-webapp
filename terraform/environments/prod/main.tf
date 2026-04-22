terraform {
  backend "s3" {
    bucket       = "serverless-app-tfstate-010741811189"
    key          = "serverless/prod/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

data "aws_region" "current" {}

locals {
  lambda_insights_layer_arns = {
    us-east-1 = "arn:aws:lambda:us-east-1:580247275435:layer:LambdaInsightsExtension:60"
    us-east-2 = "arn:aws:lambda:us-east-2:580247275435:layer:LambdaInsightsExtension:61"
    us-west-2 = "arn:aws:lambda:us-west-2:580247275435:layer:LambdaInsightsExtension:60"
  }

  lambda_insights_layer_arn = lookup(
    local.lambda_insights_layer_arns,
    data.aws_region.current.id,
    ""
  )

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

module "iam" {
  source       = "../../modules/iam"
  project_name = var.project_name
  environment  = var.environment
  unique_suffix = var.unique_suffix

  tags = local.common_tags
}

module "dynamodb" {
  source     = "../../modules/dynamodb"
  table_name = "${var.project_name}-table-${var.environment}-${var.unique_suffix}"

  tags = local.common_tags
}

module "lambda" {
  source = "../../modules/lambda"

  function_name = "${var.project_name}-lambda-${var.environment}-${var.unique_suffix}"
  role_arn      = module.iam.lambda_role_arn
  table_name    = module.dynamodb.table_name
  environment   = var.environment
  app_name      = var.app_name
  cors_origins  = var.cors_origins
  log_retention_days = 30
  lambda_insights_layer_arn = local.lambda_insights_layer_arn

  tags = local.common_tags
}

module "apigateway" {
  source = "../../modules/apigateway"

  api_name           = "${var.project_name}-api-${var.environment}-${var.unique_suffix}"
  lambda_arn        = module.lambda.lambda_arn
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
  project_name      = var.project_name
  environment       = var.environment

  tags = local.common_tags
}

module "frontend_hosting" {
  source       = "../../modules/frontend_hosting"
  bucket_name  = "${var.project_name}-frontend-${var.environment}-${var.unique_suffix}"
  project_name = var.project_name
  environment  = var.environment
  unique_suffix = var.unique_suffix

  tags = local.common_tags
}

module "monitoring" {
  source = "../../modules/monitoring"

  project_name         = var.project_name
  environment          = var.environment
  lambda_function_name = module.lambda.function_name
  api_id               = module.apigateway.api_id
  dynamodb_table_name  = module.dynamodb.table_name

  alarm_email          = var.alarm_email

  tags = local.common_tags
}

module "dashboard" {
  source = "../../modules/dashboard"

  project_name         = var.project_name
  environment          = var.environment
  lambda_function_name = module.lambda.function_name
  api_id               = module.apigateway.api_id
  dynamodb_table_name  = module.dynamodb.table_name

  tags = local.common_tags
}

module "cost" {
  source = "../../modules/cost"

  project_name   = var.project_name
  environment    = var.environment
  monthly_budget = 15
  alert_email    = var.alarm_email

  tags = local.common_tags
}
