aws_region = "eu-west-1"

# S3 buckets to be created, may need to change these if Amazon has
# not cleaned up my previous tests
# example change "dev-bucket-1" and "dev-bucket-2" keys to your preference
# then change global.tfvars where commented to match
buckets = {
  "st-bucket-1" = {
    bucket_policy    = "s3.json"
    test_key         = "folder1/"
  },
  "st-bucket-2" = {
    bucket_policy    = "s3.json"
    test_key         = "folder2/"
  },
}
