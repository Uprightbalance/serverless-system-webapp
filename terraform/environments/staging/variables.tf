variable "region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "serverless-app"
}

variable "environment" {
  default = "staging"
}

variable "unique_suffix" {
  default = "3454"
}

variable "app_name" {
  type = string
}

variable "cors_origins" {
  type = string
}

variable "enable_lambda_insights" {
  type    = bool
  default = true
}

variable "alarm_email" {
  description = "Email for CloudWatch alerts"
  type        = string
}
