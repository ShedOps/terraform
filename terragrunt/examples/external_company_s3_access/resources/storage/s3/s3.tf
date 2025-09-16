module "s3" {
  source     = "git@github.com:ShedOps/tf-modules//aws/storage/s3"  

  for_each    = var.buckets

  bucket_name = "${var.env_name}-${each.key}"
  policy      = templatefile("${path.module}/files/${var.env_name}/policy/${each.value.bucket_policy}",
                            {
                              account_id  = var.aws_account_id
                              bucket_name = "${var.env_name}-${each.key}"
                            })
  test_key    = each.value.test_key
}
