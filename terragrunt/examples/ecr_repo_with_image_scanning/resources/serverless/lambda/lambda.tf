# AWS Cloudwatch Event Rules are now known as Eventbridge rules
# This will be a terraform module at some point...
# AWS ECR Scan Pattern
resource "aws_cloudwatch_event_rule" "ecr_scan_result" {
  name        = "${var.environment}-ecr-scan-result"
  description = "Capture ECR Scanning Results"

  event_pattern = jsonencode({
    source      = ["aws.ecr"]
    detail-type = ["ECR Image Scan"]
  })

  tags = {
    environment = var.environment
  }
}
