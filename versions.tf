# Providers

# Configuring backend for Terraform state files to be saved into.
# In this case it's manually made storage bucket in GCP (lines:30-34)
terraform {
  required_version = "=1.5.6"

  required_providers {
    google = {
      source = "hashicorp/google"
      #      version = ">= 4.51.0, < 5.0, !=4.65.0, !=4.65.1"
    }
#    google-beta = {
#      source = "hashicorp/google-beta"
#    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.10"
    }
#    kubectl = {
#      source  = "gavinbunney/kubectl"
#      version = ">= 1.7.0"
#    }
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


