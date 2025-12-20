variable "alert_emails" {
  description = "Additional email addresses for ECR scan alerts"
  type        = list(string)
  default     = []
}

variable "aws_region" {
  description = "Default AWS region"
  type        = string
}

variable "cw_log_group_retention" {
  type    = number
}

variable "enable_encryption" {
  description = "Enable KMS encryption for SNS topic"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment"
  type        = string
}
