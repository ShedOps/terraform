output "bucket_arns" {
  value = {for k, v in module.s3 : k => v.bucket_arn}
}
