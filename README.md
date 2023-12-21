# CREATE
1. create gcs bucket to preserve terraform state files
2. Enable GCP APIs: <code>gcloud services enable compute.googleapis.com sqladmin.googleapis.com \
   container.googleapis.com artifactregistry.googleapis.com cloudbuild.googleapis.com</code>
3. download key file and setup GOOGLE_APPLICATION_CREDENTIALS so terraform can access gcp
4. when creating infrastructure from nothing, it's important to first run the following:
   </br><code>terraform plan -target=null_resource.docker-push-script</code>
   </br><code>terraform apply -target=null_resource.docker-push-script</code>
    


# Google Cloud Platform - Proof of concept

This is a project that explores some common GCP features.  
The infrastructure provided here is far from production-grade, but the  
concepts used to get everything to work are the latest 'de facto' standard.