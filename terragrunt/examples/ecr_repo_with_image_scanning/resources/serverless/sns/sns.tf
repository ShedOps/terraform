# sns.tf

# SNS Topic for ECR scan alerts
resource "aws_sns_topic" "ecr_scan_alerts" {
  name              = "${var.environment}-ecr-scan-alerts"
  display_name      = "ECR Vulnerability Scan Alerts"
  kms_master_key_id = var.enable_encryption ? aws_kms_key.sns[0].id : null

  tags = {
    Name        = "${var.environment}-ecr-scan-alerts"
    Environment = var.environment
    Purpose     = "ECR vulnerability scan notifications"
  }
}

resource "aws_sns_topic_subscription" "ecr_alerts_email_secondary" {
  for_each = toset(var.alert_emails)
  
  topic_arn = aws_sns_topic.ecr_scan_alerts.arn
  protocol  = "email"
  endpoint  = each.value
}

resource "aws_kms_key" "sns" {
  count = var.enable_encryption ? 1 : 0

  description             = "KMS key for SNS topic encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name        = "${var.environment}-sns-ecr-alerts-kms"
    Environment = var.environment
  }
}

resource "aws_kms_alias" "sns" {
  count = var.enable_encryption ? 1 : 0

  name          = "alias/${var.environment}-sns-ecr-alerts"
  target_key_id = aws_kms_key.sns[0].key_id
}
