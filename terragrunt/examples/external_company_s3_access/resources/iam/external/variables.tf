variable attach_bucket_policy {
}

variable attach_group {
}

variable attach_iam_policy {
}

variable aws_account_id {
}

variable aws_region {
}

variable buckets {
  type = map(object({
    bucket_policy = string
    test_key      = string
  }))
}

variable create_test_key {
}

variable env_name {
}

variable external {
  type = map(object({
    ext_account_id = string
    ext_bucket = string
    ext_policy = string
  }))
}

variable groups {
  type = map(object({
    group_bucket = string
    group_path   = string
    group_policy = string
  }))
}

variable users {
  type = map(object({
    user_group   = string
    user_path    = string
  }))
}
