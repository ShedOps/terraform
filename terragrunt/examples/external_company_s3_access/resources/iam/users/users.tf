module "iam" {
  source     = "git@github.com:ShedOps/tf-modules//aws/security/iam/user"

  for_each   = var.users

  attach_group  = var.attach_group
  attach_policy = var.attach_iam_policy
  user_name  = each.key
  user_group = each.value.user_group
  user_path  = each.value.user_path

  user_policy= templatefile("${path.module}/files/${var.env_name}/policy/default_policy.json",
               {
                 account_id  = var.aws_account_id
                 username    = each.key
               })
}
