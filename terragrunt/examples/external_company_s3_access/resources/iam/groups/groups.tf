module "group" {
  source     = "git@github.com:ShedOps/tf-modules//aws/security/iam/group"

  for_each   = var.groups

  group_name = each.key
  group_path = each.value.group_path
  group_policy = templatefile("${path.module}/files/${var.env_name}/policy/${each.value.group_policy}",
                            {
                              account_id  = var.aws_account_id
                              bucket_name = "${var.env_name}-${each.value.group_bucket}"
                            })
}
