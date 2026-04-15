resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_days
}

resource "aws_lambda_function" "app" {
  function_name = var.function_name
  role          = var.role_arn

  runtime = "python3.11"
  handler = "app.main.handler"

  filename         = "${path.module}/function.zip"
  source_code_hash = filebase64sha256("${path.module}/function.zip")

  layers = var.lambda_insights_layer_arn != "" ? [var.lambda_insights_layer_arn] : []

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.table_name
      ENVIRONMENT         = var.environment
      APP_NAME            = "MR BAFFO API"
      CORS_ORIGINS        = var.cors_origins
    }
  }
  depends_on = [
      aws_cloudwatch_log_group.lambda
  ]
}
