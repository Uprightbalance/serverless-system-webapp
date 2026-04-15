variable "function_name" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "table_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "app_name" {
  type = string
}

variable "cors_origins" {
  type = string
}


variable "log_retention_days" {
  type    = number
  default = 14
}

variable "lambda_insights_layer_arn" {
  type    = string
  default = ""
}
