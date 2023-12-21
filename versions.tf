# Configuring backend for Terraform state files to be saved into.
# In this case it's manually made storage bucket in GCP (lines:20-23)
terraform {
  required_version = "=1.5.6"

  required_providers {
    google = {
      source = "hashicorp/google"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.10"
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


