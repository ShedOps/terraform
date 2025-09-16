output "user_arns" {
  value = {for k, v in module.iam : k => v.user_arn}
}
