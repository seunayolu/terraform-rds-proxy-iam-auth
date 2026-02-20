output "repository_url" {
  description = "ECR Repository URL"
  value       = aws_ecr_repository.node_app.repository_url
}

output "ecr_repo_name" {
  description = "ECR Repository Name"
  value       = aws_ecr_repository.node_app.name
}