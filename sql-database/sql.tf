resource "random_password" "sql-instance-password" {
  length  = 16
  special = true
}

# Create Google Cloud SQL Instance
resource "google_sql_database_instance" "sql-db-instance" {
  name             = "gcp-poc-mysql-instance"
  database_version = "MYSQL_8_0_31"
  region           = var.region

  deletion_protection = false

  settings {
    tier              = "db-f1-micro"
    availability_type = "REGIONAL"
    disk_autoresize   = true

    ip_configuration {
      psc_config {
        psc_enabled               = true
        allowed_consumer_projects = [var.project-id]
      }
      ipv4_enabled = false
    }

    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }

  }
}

data "google_sql_database_instance" "db-instance-data" {
  name = google_sql_database_instance.sql-db-instance.name
}

locals {
  instance-name = data.google_sql_database_instance.db-instance-data.name
}

resource "google_sql_database" "db" {
  instance  = local.instance-name
  name      = "gcp-poc-db"
  charset   = "utf8"
  collation = "utf8_general_ci"
}

resource "google_sql_user" "application-user" {
  instance = data.google_sql_database_instance.db-instance-data.name
  name     = "app"
  password = random_password.sql-instance-password.result
}