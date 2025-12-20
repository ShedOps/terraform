# Data source to reference SNS topic from remote state
data "terraform_remote_state" "sns" {
  backend = "s3"
  config = {
    bucket = "${var.aws_account_id}-terraform-backend-state"
    key    = "env:/${var.environment}/${var.aws_region}/resources/serverless/sns/terraform.tfstate"
    region = var.aws_region
  }
}
