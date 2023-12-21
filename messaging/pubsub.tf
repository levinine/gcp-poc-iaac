# ========================================== PUBSUB TOPIC AND SUBSCRIPTION =============================================

# PubSub topic
resource "google_pubsub_topic" "weather-pubsub-topic" {
  name                       = "weather-pubsub-topic"
  message_retention_duration = "86600s"

  message_storage_policy {
    allowed_persistence_regions = [
      var.region,
    ]
  }
}

resource "google_pubsub_subscription" "weather-pubsub-subscription" {
  name  = "weather-pubsub-subscription"
  topic = google_pubsub_topic.weather-pubsub-topic.name

  message_retention_duration = "1200s"
  retain_acked_messages      = true

  ack_deadline_seconds = 20

  expiration_policy {
    ttl = "300000.5s"
  }
  retry_policy {
    minimum_backoff = "10s"
  }

  enable_message_ordering    = false
}