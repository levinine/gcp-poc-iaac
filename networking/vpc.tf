resource "google_compute_network" "private-vpc-network" {
  name                    = "gke-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke-subnet" {
  name          = "gke-subnet"
  region        = var.region
  network       = google_compute_network.private-vpc-network.name
  ip_cidr_range = "10.10.0.0/16"

  secondary_ip_range {
    range_name    = "ip-range-pods"
    ip_cidr_range = "10.20.0.0/16"
  }

  secondary_ip_range {
    range_name    = "ip-range-services"
    ip_cidr_range = "10.30.0.0/16"
  }

  secondary_ip_range {
    range_name    = "master-ipv4-range"
    ip_cidr_range = "10.40.0.0/16"
  }
}

