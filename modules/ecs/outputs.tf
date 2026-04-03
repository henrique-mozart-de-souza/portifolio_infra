output "cluster_name" {
  description = "O nome do cluster ECS criado"
  value       = aws_ecs_cluster.main.name
}