# Resource policy to allow EventBridge to write to the log group
resource "aws_cloudwatch_log_resource_policy" "eventbridge_logs" {
  policy_name = "${var.environment}-eventbridge-ecr-logs-policy"

  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.ecr_scan_events.arn}:*"
      }
    ]
  })
}

# AWS Lambda Permission to allow EventBridge to execute our lambda function
resource "aws_lambda_permission" "eventbridge_lambda" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = data.terraform_remote_state.lambda.outputs.function_name
  principal     = "events.amazonaws.com"
  source_arn    = data.terraform_remote_state.eventbridge.outputs.ecr_scan_result_eventbridge_rule_arn
}
