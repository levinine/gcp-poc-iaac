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