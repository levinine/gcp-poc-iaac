resource "google_compute_address" "internal-sql-endpoint-address" {
  name         = "psc-compute-address-${var.db-instance-name}"
  region       = var.region
  address_type = "INTERNAL"
  subnetwork   = var.gke-subnet-name
  address      = "10.10.255.240" # Arbitrary address from primary subnet range
}

data "google_sql_database_instance" "sql-instance-data" {
  name = var.db-instance-name
}

resource "google_compute_forwarding_rule" "internal-sql-address-forwarding-rule" {
  name                    = "psc-forwarding-rule-${var.db-instance-name}"
  region                  = var.region
  network                 = var.gke-vpc-name
  ip_address              = google_compute_address.internal-sql-endpoint-address.self_link
  allow_psc_global_access = true
  load_balancing_scheme   = ""
  target                  = data.google_sql_database_instance.sql-instance-data.psc_service_attachment_link
}

resource "google_dns_managed_zone" "private-dns-zone" {
  name     = "private-dns-zone"
  dns_name = regex("${var.region}\\.[a-z]{3}\\.[a-z]{4}\\.$", data.google_sql_database_instance.sql-instance-data.dns_name)

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = var.gke-vpc-id
    }
  }
}

resource "google_dns_record_set" "sql-psc-dns-record-set" {
  name         = data.google_sql_database_instance.sql-instance-data.dns_name
  managed_zone = google_dns_managed_zone.private-dns-zone.name
  type         = "A"

  rrdatas = [google_compute_address.internal-sql-endpoint-address.address]
}
