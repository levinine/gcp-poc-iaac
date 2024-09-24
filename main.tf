# Provisioning repository for Docker images which will be used in Cloud Run and GKE
resource "google_artifact_registry_repository" "gcp-poc-artifact-registry" {
  location      = var.region
  repository_id = "gcp-poc-artifact-registry"
  description   = "GCP POC private repository in Google Artifact Registry"
  format        = "DOCKER"
  mode          = "STANDARD_REPOSITORY"

  docker_config {
    immutable_tags = false
  }
}

module "networking" {
  source = "./networking"

  region     = var.region
  project-id = var.project-id
  zone       = var.zone
}

module "private-service-connect" {
  source     = "./private-service-connect"
  depends_on = [module.sql-database]

  region           = var.region
  db-instance-name = module.sql-database.sql-instance-name
  gke-subnet-name  = module.networking.private-vpc-subnet-name
  gke-vpc-name     = module.networking.private-vpc-name
  gke-vpc-id       = module.networking.private-vpc-id
}

module "iam" {
  source = "./iam"

  project-id = var.project-id
}

module "messaging" {
  source     = "./messaging"
  depends_on = [module.gke-poc]

  region = var.region
}

module "cloud-run" {
  source     = "./cloud-run"
  depends_on = [module.iam, module.messaging]

  project-id                                = var.project-id
  region                                    = var.region
  pubsub-topic-name                         = module.messaging.pubsub-topic-name
  cloud-run-service-account-email           = module.iam.cloud-run-service-account-email
  cloud-run-scheduler-service-account-email = module.iam.cloud-run-scheduler-service-account-email
}

module "sql-database" {
  source = "./sql-database"

  project-id = var.project-id
  region     = var.region
}

module "secret-manager" {
  source     = "./secret-manager"
  depends_on = [module.messaging, module.sql-database]

  region                   = var.region
  db-uri                   = module.sql-database.database-url
  db-username              = module.sql-database.application-username
  db-password              = module.sql-database.application-password
  pubsub-subscription-name = module.messaging.pubsub-subscription-name
}

module "gke-poc" {
  source     = "./gke-poc"
  depends_on = [module.networking, module.iam, module.sql-database]

  project-id              = var.project-id
  region                  = var.region
  zone                    = var.zone
  gke-cluster-version     = var.gke-cluster-version
  master-ipv4-name        = module.networking.master-ipv4-name
  master-ipv4-cidr-block  = module.networking.master-ipv4-cidr
  private-vpc-name        = module.networking.private-vpc-name
  private-vpc-subnet-name = module.networking.private-vpc-subnet-name
  pods-ip-range-name      = module.networking.private-vpc-subnet-pods-ip-range_name
  services-ip-range-name  = module.networking.private-vpc-subnet-services-ip-range_name
  node-pool-sa            = module.iam.gke-cluster-nodes-service-account
}