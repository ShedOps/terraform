resource "random_integer" "ext_company_id" {
  min = 100000000000
  max = 999999999999
}

resource "aws_ssm_parameter" "ext_company" {
  name        = "${var.env_name}-ext-company"
  description = "Random generated External ID for the simulated external company"
  type        = "SecureString"
  value       = random_integer.ext_company_id.result
}
