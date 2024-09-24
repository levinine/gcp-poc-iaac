# ========================================== CLOUD RUN JOB AND SCHEDULER SETUP =========================================

# Create Cloud Run job
resource "google_cloud_run_v2_job" "weather_data_publisher" {
  name     = "weather-data-publisher"
  location = var.region

  template {
    task_count = 1

    template {
      service_account = var.cloud-run-service-account-email
      containers {
        image = "europe-west8-docker.pkg.dev/${var.project-id}/gcp-poc-artifact-registry/weather-data-publisher:latest"

        # Adding environmental variables required for Google SDK to publish to PubSub topic
        env {
          name  = "projectId"
          value = var.project-id
        }

        env {
          name  = "topicId"
          value = var.pubsub-topic-name
        }
      }
    }
  }
}

# Cloud Run job scheduler
resource "google_cloud_scheduler_job" "cloud-run-scheduler" {
  name             = "weather-data-trigger"
  description      = "Trigger to execute the ${google_cloud_run_v2_job.weather_data_publisher.name} every two hours."
  schedule         = "*/10 * * * *" # Runs every 10 mins
  attempt_deadline = "320s"
  region           = "europe-west6" # Region had to be changed due to Scheduler jobs not being available in the region chosen for an entire project
  time_zone        = "Europe/Belgrade"

  retry_config {
    retry_count = 3
  }

  http_target {
    http_method = "POST"
    uri         = "https://${google_cloud_run_v2_job.weather_data_publisher.location}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project-id}/jobs/${google_cloud_run_v2_job.weather_data_publisher.name}:run"

    oauth_token {
      service_account_email = var.cloud-run-scheduler-service-account-email
    }
  }
}