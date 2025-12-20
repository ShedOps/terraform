variable aws_account_id {
  description = "Default AWS account id"
  type        = string
}

variable "aws_region" {
  description = "Default AWS region"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "additional_policy_arns_for_lambda_role" {
  type = list
  default = []
}

variable "cw_log_group_retention" {
  type    = number
  default = 7
}

variable "description" {
  type    = string
  default = ""
}

variable "log_group_retention_in_days" {
  type = number
  default = 7
}

variable "memory_size" {
  type    = number
  default = 128
}

variable "project_name" {
  type    = string
  default = "Sandbox"
}

variable runtime {
  type    = string
  default = "python3.9"
}

variable "timeout" {
  type    = number
  default = 299
}

variable "tracing_config" {
  type        = string
  default     = "PassThrough"
  description = "Tracing type, set to Active to enable XRay"
}

variable "zip_path" {
  type = string
  default = "python/deployment.zip"
}
