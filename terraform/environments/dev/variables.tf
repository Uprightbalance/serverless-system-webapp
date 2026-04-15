variable "region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "serverless-app"
}

variable "environment" {
  default = "dev"
}

variable "unique_suffix" {
  default = "3453"
}

variable "enable_lambda_insights" {
  type    = bool
  default = false
}

variable "alarm_email" {
  description = "Email for CloudWatch alerts"
  type        = string
}
