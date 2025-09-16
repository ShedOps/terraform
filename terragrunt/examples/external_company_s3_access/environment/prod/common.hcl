# Terraform backend config account id location and region
locals {
  env_name = basename(get_terragrunt_dir())
}

inputs = {
  aws_account_id = get_aws_account_id()
  env_name       = local.env_name
  terraform_lock = true
  tfstate_bucket = get_env("TFSTATE_BUCKET", "terraform-backend-state")
  tfstate_bucket_region = get_env("AWS_DEFAULT_REGION", "eu-west-1")
}
