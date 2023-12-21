output "pubsub-topic-name" {
  value = google_pubsub_topic.weather-pubsub-topic.name
}

output "pubsub-subscription-name" {
  value = google_pubsub_subscription.weather-pubsub-subscription.id
}