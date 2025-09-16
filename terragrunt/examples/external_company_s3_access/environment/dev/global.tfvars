# Global elements

# attach default bucket policy (secure transport)
attach_bucket_policy = "true"

# attach group to user account
attach_group = "true"

# attach iam policy direct to user (ACCESS KEY manipulation)
attach_iam_policy = "true"

# Creates the folder1 / folder2 keys in the S3 buckets (so you don't have to do it manually!)
create_test_key = "true"

# external company account id, bucket access and associted policy that defines access
# change bucket name here to match any changes you make to region env.tfvars
external = {
  "ext-company-1" = {
    ext_account_id = "123456789012" # This needs to be changed to your "client aws account id"
    ext_bucket = "st-bucket-1"
    ext_policy = "ext-company-1.json"
  },
}

# internal users
users = {
  "int-user1" = {
    user_group   = "int-users1"
    user_path    = "/"
  },
  "int-user2"    = {
    user_group   = "int-users2"
    user_path    = "/"
  },
}

# internal users groups
# change bucket names here to match any changes you make to region env.tfvars
groups = {
  "int-users1" = {
    group_path   = "/"
    group_policy = "int-users1.json"
    group_bucket = "st-bucket-1"
  },
  "int-users2" = {
    group_path   = "/"
    group_policy = "int-users2.json"
    group_bucket = "st-bucket-2"
  },
}
