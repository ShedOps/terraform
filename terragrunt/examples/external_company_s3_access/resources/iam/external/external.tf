module "role" {
  source     = "git@github.com:ShedOps/tf-modules//aws/security/iam/role"

  for_each   = var.external

  policy_name  = each.key
  role_name    = each.key

  assume_role_policy_def = templatefile("${path.module}/files/${var.env_name}/role/assume-role-iam.json",
                           {
                             ext_account = each.value.ext_account_id
                             ext_id =  aws_ssm_parameter.ext_company.value
                           })

  policy_def = templatefile("${path.module}/files/${var.env_name}/policy/${each.value.ext_policy}",
               {
                 bucket_name  = "${var.env_name}-${each.value.ext_bucket}"
               })
}
