resource "aws_lambda_function" "app" {
  function_name = var.function_name
  role          = var.role_arn

  runtime = "python3.11"
  handler = "app.handler"

  filename         = "${path.module}/function.zip"
  source_code_hash = filebase64sha256("${path.module}/function.zip")

  timeout     = 10
  memory_size = 512

  environment {
    variables = {
      TABLE_NAME  = var.table_name
      ENVIRONMENT = var.environment
      APP_NAME    = var.app_name
      CORS_ORIGINS = var.cors_origins
    }
  }
}
