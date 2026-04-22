variable "project_name" {}
variable "environment" {}
variable "lambda_function_name" {}
variable "api_id" {}
variable "dynamodb_table_name" {}

variable "tags" {
  type = map(string)
  default = {}
}

variable "aws_region" {
  type = string
}
