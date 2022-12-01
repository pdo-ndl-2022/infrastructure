output "k8s_endpoint" {
  sensitive = true
  value     = "https://${module.gke.endpoint}"
}

output "k8s_cluster_ca_certificate" {
  sensitive = true
  value     = module.gke.ca_certificate
}
