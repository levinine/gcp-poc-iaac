variable "project-id" {}

variable "credentialsFile" {}

variable "region" {
  type        = string
  description = "GCP region for resource hosting"
  default     = "europe-west8"
}

variable "zone" {
  type        = string
  description = "GCP zone for resource hosting"
  default     = "europe-west8-a"
}

variable "gke-cluster-version" {
  default = "1.27"
}

# Having custom role provisioning prohibited in the GCP project, the two variables bellow were substituted with
# existing GCP roles and individual Service Account binding for each. (main.tf:131-141)

#variable "cloudRunPermissions" {
#  type        = list(string)
#  description = "Permissions granted to Cloud Run job"
#  default     = ["pubsub.topics.publish", "roles/logging.logWriter"]
#}
#
#variable "cloudRunInvokerPermissions" {
#  type        = list(string)
#  description = "Permissions granted to Cloud Run job scheduler"
#  default     = ["run.jobs.run", "run.routes.invoke", "logging.logEntries.create", "logging.logEntries.route"]
#}