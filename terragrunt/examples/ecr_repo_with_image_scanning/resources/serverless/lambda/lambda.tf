# ECR Scanner Lambda Function
module "ecr_scan_function" {
  source                                 = "git@github.com:ShedOps/tf-modules//aws/serverless/lambda"

  # Lambda function specifics
  zip_path                               = var.zip_path
  environment                            = var.environment
  function_name                          = "${var.environment}-ecr-scanner-lambda"
  handler                                = "main.lambda_handler"
  log_group_retention_in_days            = var.log_group_retention_in_days
  memory_size                            = var.memory_size
  project_name                           = var.project_name
  runtime                                = var.runtime
  timeout                                = var.timeout
  tracing_config                         = var.tracing_config
  # Pass SNS publish policy ARN
  additional_policy_arns_for_lambda_role = [
    aws_iam_policy.lambda_sns_publish.arn,
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
  os_env_vars = { 
    ENVIRONMENT                          = var.environment
    SNS_TOPIC_ARN                        = data.terraform_remote_state.sns.outputs.sns_topic_arn
    LOG_LEVEL                            = "INFO"
  }
}
