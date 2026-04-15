variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "log_retention_days" {
  type    = number
  default = 14
}

variable "api_name" {
  type = string
}

variable "lambda_arn" {}
variable "lambda_invoke_arn" {}
