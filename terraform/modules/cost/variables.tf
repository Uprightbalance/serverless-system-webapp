variable "project_name" {}
variable "environment" {}
variable "monthly_budget" {}
variable "alert_email" {}

variable "tags" {
  type = map(string)
  default = {}
}
