output arn {
  value       = module.ecr_scan_function.arn
  description = "Lambda function arn"
}

output function_name {
  value       = module.ecr_scan_function.function_name
  description = "The name of the Lambda function"
}

output role_arn {
  value       = module.ecr_scan_function.role_arn
  description = "IAM role arn"
}

output invoke_arn {
  value       = module.ecr_scan_function.invoke_arn
  description = "The Lambda function invoke arn"
}
