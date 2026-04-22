resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-${var.environment}-dashboard"

  dashboard_body = jsonencode({
    widgets = [

      {
        type = "metric"
        x = 0
        y = 0
        width = 12
        height = 6

        properties = {
          title  = "Lambda Invocations"
          region = var.aws_region

          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", var.lambda_function_name]
          ]

          stat   = "Sum"
          period = 300

          annotations = {}
        }
      },

      {
        type = "metric"
        x = 12
        y = 0
        width = 12
        height = 6

        properties = {
          title  = "Lambda Errors"
          region = var.aws_region

          metrics = [
            ["AWS/Lambda", "Errors", "FunctionName", var.lambda_function_name]
          ]

          stat   = "Sum"
          period = 300

          annotations = {}
        }
      },

      {
        type = "metric"
        x = 0
        y = 6
        width = 12
        height = 6

        properties = {
          title  = "Lambda Duration"
          region = var.aws_region

          metrics = [
            ["AWS/Lambda", "Duration", "FunctionName", var.lambda_function_name]
          ]

          stat   = "Average"
          period = 300

          annotations = {}
        }
      },

      {
        type = "metric"
        x = 12
        y = 6
        width = 12
        height = 6

        properties = {
          title  = "API Gateway Requests"
          region = var.aws_region

          metrics = [
            ["AWS/ApiGateway", "Count", "ApiId", var.api_id]
          ]

          stat   = "Sum"
          period = 300

          annotations = {}
        }
      },

      {
        type = "metric"
        x = 0
        y = 12
        width = 12
        height = 6

        properties = {
          title  = "DynamoDB Read Usage"
          region = var.aws_region

          metrics = [
            ["AWS/DynamoDB", "ConsumedReadCapacityUnits", "TableName", var.dynamodb_table_name]
          ]

          stat   = "Sum"
          period = 300

          annotations = {}
        }
      }
    ]
  })
}
