locals {
  # Fetching available zones from the region and taking first two for nodes location
  node-locations              = join(",", element(chunklist(data.google_compute_zones.zones-within-region.names, 2), 0))
}

data "google_compute_zones" "zones-within-region" {
  region = var.region
}

data "google_client_config" "my-local-config" {}

module "gke" {
  source                   = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id               = var.project-id
  name                     = "gcp-poc-gke-cluster"
  kubernetes_version       = var.gke-cluster-version
  regional                 = true
  region                   = var.region
  deletion_protection      = false
  node_metadata            = "GKE_METADATA"
  identity_namespace       = "${var.project-id}.svc.id.goog"
  remove_default_node_pool = true
  initial_node_count       = 0
  ip_range_pods            = var.pods-ip-range-name
  ip_range_services        = var.services-ip-range-name
  network                  = var.private-vpc-name
  subnetwork               = var.private-vpc-subnet-name
  service_account          = var.node-pool-sa

  node_pools = [
    {
      name           = "gke-cluster-node-pool"
      machine_type   = "e2-medium" # --> more resources are needed if running Cloud SQL auth proxy as a sidecar (e2-standard-4 for example)
      node_locations = local.node-locations
      min_count      = 1
      max_count      = 2
      disk_size_gb   = 30
    }
  ]
  master_global_access_enabled = true
  master_authorized_networks = [
    {
      cidr_block   = var.master-ipv4-cidr-block
      display_name = "master-auth-network"
    }
  ]
  enable_private_nodes    = true
  enable_private_endpoint = true
  master_ipv4_cidr_block  = var.master-ipv4-cidr-block
}

data "google_container_cluster" "poc-cluster" {
  name     = module.gke.name
  location = module.gke.region
}

resource "google_compute_instance" "bastion-host" {
  name         = "bastion-host"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network    = var.private-vpc-name
    subnetwork = var.private-vpc-subnet-name
  }

  metadata_startup_script = file("${path.module}/bastion-startup-script.sh")
}

resource "null_resource" "generate-kubeconfig" {
  triggers = {
    cluster_ca_certificate = data.google_container_cluster.poc-cluster.master_auth.0.cluster_ca_certificate
    endpoint               = data.google_container_cluster.poc-cluster.endpoint
  }

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${data.google_container_cluster.poc-cluster.name} --region ${data.google_container_cluster.poc-cluster.location}"
  }

  depends_on = [module.gke, google_compute_instance.bastion-host]
}