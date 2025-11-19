#######################################################
# AWS ECR Scan Result (via EventBridge)
#######################################################
resource "aws_cloudwatch_log_group" "ecr_scan_events" {
  name              = "/aws/events/${var.environment}-ecr-scan-events"
  retention_in_days = var.cw_log_group_retention

  tags = {
    Environment     = var.environment
    Purpose         = "ECR Scan Event Debugging"
  }
}

# Target CW Log Group
resource "aws_cloudwatch_event_target" "ecr_scan_logs" {
  rule              = data.terraform_remote_state.eventbridge.outputs.ecr_scan_result_eventbridge_rule_id
  target_id         = "ECRScanLogTarget"
  arn               = aws_cloudwatch_log_group.ecr_scan_events.arn
}
