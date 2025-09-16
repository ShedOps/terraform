output "group_arns" {
  value = {for k, v in module.group : k => v.group_arn}
}
