resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-${var.environment}-dashboard"

  dashboard_body = jsonencode({
    widgets = [

      # 🔹 Lambda Invocations
      {
        type = "metric"
        x    = 0
        y    = 0
        width  = 12
        height = 6

        properties = {
          title = "Lambda Invocations"
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", var.lambda_function_name]
          ]
          stat   = "Sum"
          period = 300
        }
      },

      # 🔹 Lambda Errors
      {
        type = "metric"
        x    = 12
        y    = 0
        width  = 12
        height = 6

        properties = {
          title = "Lambda Errors"
          metrics = [
            ["AWS/Lambda", "Errors", "FunctionName", var.lambda_function_name]
          ]
          stat   = "Sum"
          period = 300
        }
      },

      # 🔹 Lambda Duration
      {
        type = "metric"
        x    = 0
        y    = 6
        width  = 12
        height = 6

        properties = {
          title = "Lambda Duration"
          metrics = [
            ["AWS/Lambda", "Duration", "FunctionName", var.lambda_function_name]
          ]
          stat   = "Average"
          period = 300
        }
      },

      # 🔹 API Gateway Requests
      {
        type = "metric"
        x    = 12
        y    = 6
        width  = 12
        height = 6

        properties = {
          title = "API Gateway Requests"
          metrics = [
            ["AWS/ApiGateway", "Count", "ApiId", var.api_id]
          ]
          stat   = "Sum"
          period = 300
        }
      },

      # 🔹 DynamoDB Consumed Read Capacity
      {
        type = "metric"
        x    = 0
        y    = 12
        width  = 12
        height = 6

        properties = {
          title = "DynamoDB Read Usage"
          metrics = [
            ["AWS/DynamoDB", "ConsumedReadCapacityUnits", "TableName", var.dynamodb_table_name]
          ]
          stat   = "Sum"
          period = 300
        }
      }
    ]
  })
}
