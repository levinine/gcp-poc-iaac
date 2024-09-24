output "db-uri-id" {
  value = google_secret_manager_secret.db-uri.id
}

output "db-username-id" {
  value = google_secret_manager_secret.db-username.id
}

output "db-password-id" {
  value = google_secret_manager_secret.db-password.id
}

output "pubsub-subscription-id" {
  value = google_secret_manager_secret.pubsub-subscription-name.id
}