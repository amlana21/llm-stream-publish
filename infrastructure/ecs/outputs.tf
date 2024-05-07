

output "ecs_cluster_id" {
    value = aws_ecs_cluster.app_cluster.id
}

output "cluster_name" {
    value = aws_ecs_cluster.app_cluster.name
  
}
