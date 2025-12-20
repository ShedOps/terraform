output "sns_topic_arn" {
  description = "ARN of the ECR scan alerts SNS topic"
  value       = aws_sns_topic.ecr_scan_alerts.arn
}

output "sns_topic_name" {
  description = "Name of the ECR scan alerts SNS topic"
  value       = aws_sns_topic.ecr_scan_alerts.name
}
