data "aws_caller_identity" "current" {}

data "terraform_remote_state" "eventbridge" {
  backend = "s3"

  config = {
    bucket = "${data.aws_caller_identity.current.account_id}-${var.tfstate_bucket}"

    key    = "env:/${var.environment}/${var.aws_region}/resources/serverless/eventbridge/terraform.tfstate"
    region = var.aws_region
  }
}
