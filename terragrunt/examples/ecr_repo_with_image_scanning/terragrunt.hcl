locals {
  aws_region        = get_env("AWS_DEFAULT_REGION")
  env_file          = get_env("TF_VAR_env_file")

  common_vars       = read_terragrunt_config(find_in_parent_folders("environment/${local.env_file}/common.hcl"))
}

inputs = {
  aws_account_id        = local.common_vars.inputs.aws_account_id
  env_name              = local.common_vars.inputs.env_name
  terraform_lock        = local.common_vars.inputs.terraform_lock
  tfstate_bucket        = local.common_vars.inputs.tfstate_bucket
  tfstate_bucket_region = local.common_vars.inputs.tfstate_bucket_region
}

# This block specifies account, bucket name, locking and region for TF state / lock file
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${local.common_vars.inputs.aws_account_id}-${local.common_vars.inputs.tfstate_bucket}"
    key            = "env:/${local.env_file}/${local.aws_region}/${path_relative_to_include()}/terraform.tfstate"
    region         = local.common_vars.inputs.tfstate_bucket_region
    use_lockfile   = local.common_vars.inputs.terraform_lock
  }
}

terraform {
  extra_arguments "modules" {
    commands  = ["get"]
    arguments = ["-update=true"]
  }

  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = ["-lock-timeout=20m"]
  }

  # This traverses the relevant global and region specific variables files when "terragrunt apply-all / plan / destroy-all" is executed
  extra_arguments "vars" {
    commands = get_terraform_commands_that_need_vars()

    required_var_files = [
      "${get_parent_terragrunt_dir()}/environment/${local.env_file}/global.tfvars",
      "${get_parent_terragrunt_dir()}/environment/${local.env_file}/${local.aws_region}/env.tfvars",
    ]

  }

  extra_arguments "backups" {
    commands  = ["apply"]
    arguments = ["-backup=-"]
  }

}
