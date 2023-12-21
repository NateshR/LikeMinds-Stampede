output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = data.google_container_cluster.likeminds-load-testing-autopilot-cluster.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = data.google_container_cluster.likeminds-load-testing-autopilot-cluster.endpoint
  description = "GKE Cluster Host"
}
