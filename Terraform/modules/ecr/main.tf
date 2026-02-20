resource "aws_ecr_repository" "node_app" {
  name                 = var.repo_name
  image_tag_mutability = "IMMUTABLE_WITH_EXCLUSION"

  image_tag_mutability_exclusion_filter {
    filter      = "latest*"
    filter_type = "WILDCARD"
  }

  force_delete = true

  tags = {
    Name        = "${var.project_name}-ecr-node-app"
    Environment = var.environment
  }
}