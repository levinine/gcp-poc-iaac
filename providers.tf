provider "google" {
  project     = var.project-id
  credentials = file(var.credentialsFile)
  region      = var.region
  zone        = var.zone
}

#provider "google-beta" {
#  project     = var.project-id
#  credentials = file(var.credentialsFile)
#  region      = var.region
#  zone        = var.zone
#}

provider "kubernetes" {
  host                   = module.gke-poc.host
  token                  = module.gke-poc.token
  cluster_ca_certificate = module.gke-poc.cluster-ca-certificate
}

#provider "kubectl" {
#  host = module.gke-poc.host
#}