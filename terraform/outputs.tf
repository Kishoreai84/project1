output "cluster_name" {
  description = "GKE Cluster Name"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "GKE Cluster Endpoint"
  value       = google_container_cluster.primary.endpoint
}

output "load_balancer_ip" {
  description = "Load Balancer IP Address"
  value       = kubernetes_service.webapp.status.0.load_balancer.0.ingress.0.ip
}

output "project_id" {
  description = "GCP Project ID"
  value       = var.project_id
}