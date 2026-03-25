output "lambda_arn" {
  value = aws_lambda_function.app.arn
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.app.invoke_arn
}

output "function_name" {
  value = aws_lambda_function.app.function_name
}
