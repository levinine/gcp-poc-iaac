terraform {
  required_version = "=1.5.6"

  required_providers {
    google = {
      source = "hashicorp/google"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.1"
    }
  }

  backend "gcs" {
    bucket = "terraform-state-files-gcp-poc-l9"
    prefix = "terraform/state"
  }
}


