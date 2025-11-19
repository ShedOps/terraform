output "ecr_scan_result_eventbridge_rule_arn" {
  value = aws_cloudwatch_event_rule.ecr_scan_result.arn
}

output "ecr_scan_result_eventbridge_rule_id" {
  value = aws_cloudwatch_event_rule.ecr_scan_result.id
}
