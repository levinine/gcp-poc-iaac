resource "google_compute_router" "private-network-nat-router" {
  name    = "my-router"
  region  = google_compute_subnetwork.gke-subnet.region
  network = google_compute_network.private-vpc-network.id
}

resource "google_compute_router_nat" "private-network-nat-gateway" {
  name                               = "bastion-nat-gateway"
  router                             = google_compute_router.private-network-nat-router.name
  region                             = google_compute_router.private-network-nat-router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES"
}

resource "google_compute_firewall" "allow_ssh_ingress_from_iap" {
  name     = "allow-ssh-ingress-from-iap"
  network  = google_compute_network.private-vpc-network.name
  priority = 998

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]

  direction = "INGRESS"
}