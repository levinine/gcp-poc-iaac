/*
As a general rule, it's recommended using predefined roles to limit complexity.
In some cases, it can make sense for customers to manage custom roles themselves,
but this decision should be carefully considered, given the additional overhead associated with it.
                       ^
                       |
                   Refactor
*/


# ======================================================================================================================
# ======================================| SERVICE ACCOUNTS SECTION |====================================================
# ======================================================================================================================

#                                       ___________________________
#                                      | Cloud Run Service Account |
#                                       ===========================

resource "google_service_account" "cloud-run-job-service-account" {
  account_id   = "cloud-run-job-sa"
  display_name = "Cloud Run Service Account"
  description  = "Service Account for Weather data publisher to publish to PubSub"
}

#                                    _________________________________
#                                   | Cloud Scheduler Service Account |
#                                    =================================

resource "google_service_account" "cloud-run-job-scheduler-service-account" {
  account_id   = "cloud-run-job-scheduler-sa"
  display_name = "Cloud Run scheduler Service Account"
  description  = "Service Account for Weather data publisher trigger to execute the Cloud Run job"
}

#                                          _____________________
#                                         | GKE Service Account |
#                                          =====================

resource "google_service_account" "gke-cluster-service-account" {
  account_id   = "gke-cluster-sa"
  display_name = "GKE cluster service account"
}

#                                          _____________________
#                                         | Pods Service Account |
#                                          =====================

resource "google_service_account" "pod-service-account" {
  account_id   = local.pod-sa-name
  display_name = "GKE pod service account"
}

# ======================================================================================================================
# =======================================| SERVICE ACCOUNT BINDINGS |===================================================
# ======================================================================================================================

#                                        _______________________
#                                       | Cloud Run SA bindings |
#                                        =======================

resource "google_project_iam_member" "pubsub-publisher-to-cr" {
  project = var.project-id
  member  = "serviceAccount:${google_service_account.cloud-run-job-service-account.email}"
  role    = "roles/pubsub.publisher"
}

resource "google_project_iam_member" "log-writer-to-cr" {
  project = var.project-id
  member  = "serviceAccount:${google_service_account.cloud-run-job-service-account.email}"
  role    = "roles/logging.logWriter"
}

#                                     _____________________________
#                                    | Cloud Scheduler SA bindings |
#                                     =============================

resource "google_project_iam_member" "log-writer-to-crs" {
  project = var.project-id
  member  = "serviceAccount:${google_service_account.cloud-run-job-scheduler-service-account.email}"
  role    = "roles/logging.logWriter"
}

resource "google_project_iam_member" "job-invoker-to-crs" {
  project = var.project-id
  member  = "serviceAccount:${google_service_account.cloud-run-job-scheduler-service-account.email}"
  role    = "roles/run.invoker"
}

#                                        _______________________
#                                       |   GKE SA bindings     |
#                                        =======================

resource "google_project_iam_member" "log-writer-to-gke" {
  project = var.project-id
  member  = "serviceAccount:${google_service_account.gke-cluster-service-account.email}"
  role    = "roles/logging.logWriter"
}

resource "google_project_iam_member" "artifact-registry-reader-to-gke" {
  project = var.project-id
  member  = "serviceAccount:${google_service_account.gke-cluster-service-account.email}"
  role    = "roles/artifactregistry.reader"
}

resource "google_project_iam_member" "compute-service-agent-to-gke" {
  project = var.project-id
  member  = "serviceAccount:${google_service_account.gke-cluster-service-account.email}"
  role    = "roles/compute.serviceAgent"
}

#                                      ___________________________
#                                     |   K8s pod SA bindings     |
#                                      ===========================

locals {
  pod-sa-name   = "pod-service-account-mapped"
  k8s-namespace = "default"
}

resource "google_project_iam_member" "log-writer-to-pod" {
  project = var.project-id
  member  = "serviceAccount:${google_service_account.pod-service-account.email}"
  role    = "roles/logging.logWriter"
}

resource "google_project_iam_member" "sql-instance-user-to-pod" {
  project = var.project-id
  member  = "serviceAccount:${google_service_account.pod-service-account.email}"
  role    = "roles/cloudsql.instanceUser"
}

resource "google_project_iam_member" "sql-admin-to-pod" {
  project = var.project-id
  member  = "serviceAccount:${google_service_account.pod-service-account.email}"
  role    = "roles/cloudsql.admin"
}

resource "google_project_iam_member" "dns-admin-to-pod" {
  project = var.project-id
  member  = "serviceAccount:${google_service_account.pod-service-account.email}"
  role    = "roles/dns.admin"
}

resource "google_project_iam_member" "pubsub-subscriber-to-pod" {
  project = var.project-id
  member  = "serviceAccount:${google_service_account.pod-service-account.email}"
  role    = "roles/pubsub.subscriber"
}

resource "google_project_iam_member" "secret-manager-viewer-to-pod" {
  project = var.project-id
  member  = "serviceAccount:${google_service_account.pod-service-account.email}"
  role    = "roles/secretmanager.viewer"
}

resource "google_project_iam_member" "secret-manager-secret-accessor-to-pod" {
  project = var.project-id
  member  = "serviceAccount:${google_service_account.pod-service-account.email}"
  role    = "roles/secretmanager.secretAccessor"
}

resource "google_service_account_iam_member" "workload-identity-user-assignment" {
  service_account_id = google_service_account.pod-service-account.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project-id}.svc.id.goog[${local.k8s-namespace}/${local.pod-sa-name}]"
}