variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "tags" {
  type = map(string)
  default = {}
}
