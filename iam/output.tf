output "cloud-run-service-account-email" {
  value = google_service_account.cloud-run-job-service-account.email
}

output "cloud-run-scheduler-service-account-email" {
  value = google_service_account.cloud-run-job-scheduler-service-account.email
}

output "gke-cluster-nodes-service-account" {
  value = google_service_account.gke-cluster-nodes-service-account.email
}

output "create-k8s-service-account" {
  value = "kubectl create serviceaccount -n ${local.k8s-namespace} ${local.pod-sa-name}"
}

output "annotate-k8s-sa-to-iam-sa" {
  value = "kubectl annotate serviceaccount -n ${local.k8s-namespace} ${local.pod-sa-name} iam.gke.io/gcp-service-account=${google_service_account.pod-service-account.email}"
}