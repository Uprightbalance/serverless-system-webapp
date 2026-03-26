module "iam" {
  source       = "../../modules/iam"
  project_name = var.project_name
  environment  = var.environment 
}

module "dynamodb" {
  source     = "../../modules/dynamodb"
  table_name = "${var.project_name}-table-${var.environment}"
}

module "lambda" {
  source = "../../modules/lambda"

  function_name = "${var.project_name}-lambda-${var.environment}"
  role_arn      = module.iam.lambda_role_arn
  table_name    = module.dynamodb.table_name
  environment   = var.environment
}

module "apigateway" {
  source = "../../modules/apigateway"

  lambda_arn        = module.lambda.lambda_arn
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
}

module "frontend_hosting" {
  source       = "../../modules/frontend_hosting"
  bucket_name  = "${var.project_name}-frontend-${var.environment}-3453"
  project_name = var.project_name
  environment  = var.environment
}
