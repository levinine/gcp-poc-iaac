resource "google_secret_manager_secret" "db-uri" {
  secret_id = "db-uri"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "sql-instance-uri-final-v" {
  secret      = google_secret_manager_secret.db-uri.id
  secret_data = var.db-uri
}

data "google_secret_manager_secret" "db-uri-data" {
  secret_id = google_secret_manager_secret.db-uri.secret_id
}

# ======================================================================================================================

resource "google_secret_manager_secret" "db-username" {
  secret_id = "db-username"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "db-username-final-v" {
  secret      = google_secret_manager_secret.db-username.id
  secret_data = var.db-username
}

# ======================================================================================================================

resource "google_secret_manager_secret" "db-password" {
  secret_id = "db-password"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "db-password-final-v" {
  secret      = google_secret_manager_secret.db-password.id
  secret_data = var.db-password
}

# ======================================================================================================================

resource "google_secret_manager_secret" "pubsub-subscription-name" {
  secret_id = "pubsub-subscription-name"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "pubsub-subscription-name-final-v" {
  secret      = google_secret_manager_secret.pubsub-subscription-name.id
  secret_data = var.pubsub-subscription-name
}