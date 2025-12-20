# Create SNS publish policy
resource "aws_iam_policy" "lambda_sns_publish" {
  name        = "${var.environment}-lambda-ecr-scan-sns-publish"
  description = "Allow Lambda to publish messages to ECR scan alerts SNS topic"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "sns:Publish"
      ]
      Resource = data.terraform_remote_state.sns.outputs.sns_topic_arn
    }]
  })

  tags = {
    Name        = "${var.environment}-lambda-ecr-scan-sns-publish"
    Environment = var.environment
  }
}
