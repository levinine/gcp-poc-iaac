locals {
  iap-port = "8888"
}

output "run-to-specify-proxy" {
  value = "export HTTPS_PROXY=localhost:${local.iap-port}"
}

output "run-to-tunnel-to-bastion-via-iap" {
  value = "gcloud compute ssh ${module.gke-poc.bastion-host-name} \\\n\t--tunnel-through-iap \\\n\t--project ${var.project-id} \\\n\t--zone ${var.zone} \\\n\t--ssh-flag \"-4 -L${local.iap-port}:localhost:${local.iap-port} -N -q -f\""
}

output "create-k8s-service-account-command" {
  value = module.iam.create-k8s-service-account
}

output "annotate-k8s-service-account-with-google-service-account" {
  value = module.iam.annotate-k8s-sa-to-iam-sa
}

output "run-to-stop-listening-on-remote-client_for-mac-os" {
  value = "lsof -i -n -P | grep ${local.iap-port} | awk '{print $2}' | grep -o '[0-9]\\+' | sort -u | xargs sudo kill"
}

# ========================
# ========================
# ========================

output "db-uri-id" {
  value = module.secret-manager.db-uri-id
}

output "db-username-id" {
  value = module.secret-manager.db-username-id
}

output "db-password-id" {
  value = module.secret-manager.db-password-id
}

output "pubsub-subscription-id" {
  value = module.secret-manager.pubsub-subscription-id
}