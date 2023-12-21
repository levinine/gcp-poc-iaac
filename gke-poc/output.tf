output "bastion-host-name" {
  value = google_compute_instance.bastion-host.name
}

output "host" {
  value = "https://${module.gke.endpoint}"
}

output "token" {
  value = data.google_client_config.my-local-config.access_token
}

output "cluster-ca-certificate" {
  value = base64decode(module.gke.ca_certificate) //data.google_container_cluster.poc-cluster.master_auth.0.cluster_ca_certificate
}
