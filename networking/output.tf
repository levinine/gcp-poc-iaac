output "private-vpc" {
  value = google_compute_network.private-vpc-network.self_link
}

output "private-vpc-id" {
  value = google_compute_network.private-vpc-network.id
}

output "private-vpc-name" {
  value = google_compute_network.private-vpc-network.name
}

output "private-vpc-subnet-name" {
  value = google_compute_subnetwork.gke-subnet.name
}

output "private-vpc-subnet-pods-ip-range_name" {
  value = google_compute_subnetwork.gke-subnet.secondary_ip_range[0].range_name
}

output "private-vpc-subnet-services-ip-range_name" {
  value = google_compute_subnetwork.gke-subnet.secondary_ip_range[1].range_name
}

output "bastion-ssh-ingress" {
  value = google_compute_firewall.allow_ssh_ingress_from_iap.self_link
}

output "bastion-egress" {
  value = google_compute_router_nat.private-network-nat-gateway.id
}