resource "aws_ecr_repository" "node_app" {
  name                 = var.repo_name
  image_tag_mutability = "IMMUTABLE"

  force_delete = true

  tags = {
    Name        = "${var.project_name}-ecr-node-app"
    Environment = var.environment
  }
}