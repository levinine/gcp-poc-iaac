/*
As a general rule, it's recommended using predefined roles to limit complexity.
In some cases, it can make sense for customers to manage custom roles themselves,
but this decision should be carefully considered, given the additional overhead associated with it.
                       ^
                       |
                   Refactor
*/


locals {
  log-writer = "roles/logging.logWriter"

  gke-pods-roles = [local.log-writer, "roles/cloudsql.instanceUser", "roles/cloudsql.admin", "roles/dns.admin",
  "roles/pubsub.subscriber", "roles/secretmanager.secretAccessor", "roles/secretmanager.viewer"]
  gke-nodes-roles           = ["roles/compute.serviceAgent", "roles/artifactregistry.reader", local.log-writer]
  cloud-run-roles           = ["roles/pubsub.publisher", local.log-writer]
  cloud-run-scheduler-roles = ["roles/run.invoker", local.log-writer]

  pod-sa-name   = "pod-service-account-mapped"
  k8s-namespace = "default"
}

resource "google_service_account" "cloud-run-job-service-account" {
  account_id   = "cloud-run-job-sa"
  display_name = "Cloud Run Service Account"
  description  = "Service Account for Weather data publisher to publish to PubSub"
}

resource "google_service_account" "cloud-run-job-scheduler-service-account" {
  account_id   = "cloud-run-job-scheduler-sa"
  display_name = "Cloud Run scheduler Service Account"
  description  = "Service Account for Weather data publisher trigger to execute the Cloud Run job"
}

resource "google_service_account" "gke-cluster-nodes-service-account" {
  account_id   = "gke-cluster-nodes-sa"
  display_name = "GKE cluster nodes service account"
}

resource "google_service_account" "pod-service-account" {
  account_id   = local.pod-sa-name
  display_name = "GKE pod service account"
}

# ======================================================================================================================
# =======================================| SERVICE ACCOUNT BINDINGS |===================================================
# ======================================================================================================================

resource "google_project_iam_member" "cloud-run-role-binding" {
  for_each = toset(local.cloud-run-roles)

  member  = "serviceAccount:${google_service_account.cloud-run-job-service-account.email}"
  project = var.project-id
  role    = each.value
}

resource "google_project_iam_member" "cloud-run-scheduler-role-binding" {
  for_each = toset(local.cloud-run-scheduler-roles)

  member  = "serviceAccount:${google_service_account.cloud-run-job-scheduler-service-account.email}"
  project = var.project-id
  role    = each.value
}

resource "google_project_iam_member" "gke-nodes-roles-binding" {
  for_each = toset(local.gke-nodes-roles)

  member  = "serviceAccount:${google_service_account.gke-cluster-nodes-service-account.email}"
  project = var.project-id
  role    = each.value
}

resource "google_project_iam_member" "gke-pods-roles-binding" {
  for_each = toset(local.gke-pods-roles)

  member  = "serviceAccount:${google_service_account.pod-service-account.email}"
  project = var.project-id
  role    = each.value
}

resource "google_project_iam_member" "workload-identity-user-assignment" {
  project = var.project-id
  role    = "roles/iam.workloadIdentityUser"
  member  = "serviceAccount:${var.project-id}.svc.id.goog[${local.k8s-namespace}/${local.pod-sa-name}]"
}