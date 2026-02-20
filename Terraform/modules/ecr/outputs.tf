output "registry" {
  description = "ECR Registry"
  value       = aws_ecr_repository.node_app.registry_id
}

output "ecr_repo_name" {
  description = "ECR Repository Name"
  value       = aws_ecr_repository.node_app.name
}