variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "unique_suffix" {
  type = string
}

variable "lambda_insights_layer_arn" {
  type    = string
  default = ""
}

variable "tags" {
  type = map(string)
  default = {}
}
