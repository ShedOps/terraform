variable "aws_region" {
  description = "Default AWS region"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "tfstate_bucket" {
  description = "S3 bucket backend for terraform state lookups"
  type        = string
}

# Custom variables
variable "cw_log_group_retention" {
  description = "Default retention period for CloudWatch Log Groups"
  type        = number
}
