resource "aws_ecr_repository" "devops_tooling_repo" {
  name                 = "devops-${var.environment}-tooling-repo"

  encryption_configuration {
    encryption_type      = "AES256"
  }
  
  image_tag_mutability = "IMMUTABLE_WITH_EXCLUSION"  # All tags immutable by default, with exceptions

  # Allow overwriting of tags matching latest* pattern
  # Example: v1.0.0 cannot be overwritten
  #          latest          - can overwrite
  #          latest-dev      - can overwrite
  image_tag_mutability_exclusion_filter {
    filter      = "latest*"
    filter_type = "WILDCARD"
  }

  # Allow overwriting of tags matching dev* pattern
  # Example: v1.0.0 cannot be overwritten
  #          dev-feature-123 - can overwrite etc
  image_tag_mutability_exclusion_filter {
    filter      = "dev-*"
    filter_type = "WILDCARD"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = var.environment
  }
}
