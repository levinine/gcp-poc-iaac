provider "google" {
  project     = var.project-id
  credentials = file(var.credentialsFile)
  region      = var.region
  zone        = var.zone
}