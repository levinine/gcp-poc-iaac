# CREATE
1. create gcs bucket to preserve terraform state files
2. Enable GCP APIs: <code>gcloud services enable compute.googleapis.com sqladmin.googleapis.com \
   container.googleapis.com artifactregistry.googleapis.com cloudbuild.googleapis.com</code>
3. download key file and setup GOOGLE_APPLICATION_CREDENTIALS so terraform can access gcp
4. when creating infrastructure from nothing, it's important to first run the following:
   </br><code>terraform plan -target=null_resource.docker-push-script</code>
   </br><code>terraform apply -target=null_resource.docker-push-script</code>
    


# Google Cloud Platform - Proof of concept

This is a project that explores some common GCP features. The infrastructure provided here is far from production-grade,  
but the concepts used to get everything to work are the latest 'de facto' standard and Google-recommended.

<figure>
   <img src="gcp-poc-architecture.png" width="750" height="390" alt="./gcp-poc-architecture.png">
   <figcaption>
      Full-sized image is 'gcp-poc-architecture.png'
   </figcaption>
</figure>

If you prefer diagrams to text, opening up full-sized image from above will point you do the submodules you're interested in.

If you want to skip down to business you can go to [How to run](#how-to-run-). Otherwise, let's analyse the image from above. Bellow are descriptions,  
module-by-module, with some (like IAM and Networking provisioning) being mentioned through-out all the individual descriptions.

### Google Kubernetes Engine

At the center of this setup lies [VPC-native Kubernetes cluster](https://cloud.google.com/kubernetes-engine/docs/concepts/alias-ips) running two nodes (each being deployed to two separate zones) with two pods running the same service (We'll address the service later). The service exposes the API to end-users. The nodes are private as well as the control plane's endpoint, thus administrating the cluster is done via [Bastion jump host](https://cloud.google.com/solutions/connecting-securely#external) (SSH via Identity-aware proxy tunnelling). SSH proxying is configured by the startup script defined in the **gke-poc** submodule and for specific networking setup required for this to work, look at the list below.

The resources for everything related to GKE:
- [GKE cluster and Bastion Jump host](https://github.com/levinine/gcp-poc-iaac/tree/main/gke-poc)
- [Virtual Private Cloud and subnetwork](https://github.com/levinine/gcp-poc-iaac/tree/main/networking)
- [Specific setup for proxying through Bastion VM](https://github.com/levinine/gcp-poc-iaac/tree/main/networking/firewall-ingress-nat.tf)
- [Service accounts and role bindings](https://github.com/levinine/gcp-poc-iaac/tree/main/iam)


### Cloud SQL

MySQL is specific server doing the job. 


## How to run 

Before going any further here's a list of required permissions to fully provision and deploy  
this POC to work:

- Compute Instance Admin (v1)
- Compute Network Admin
- IAM Workload Identity Pool Admin
- IAP-secured Tunnel User
- Secret Manager Admin
- Service Account Admin
- Artifact Registry Administrator 
- DNS Administrator
- Project IAM Admin
- IAM Service Account Admin
- Pub/Sub Editor
- Cloud Run Admin
- Cloud Scheduler Admin 
- Cloud SQL Admin
- Secret Manager Admin
- Kubernetes Engine Admin

...and a list of GCP APIs to enable for this POC to work:

- Cloud Logging API
- Compute Engine API
- Cloud Monitoring API
- Kubernetes Engine API
- Cloud Run Admin API
- Cloud Pub/Sub API
- IAM Service Account Credentials API
- Security Token Service API
- Cloud DNS API
- Artifact Registry API
- Cloud Scheduler API
- Secret Manager API
- Identity and Access Management (IAM) API



Manually creating storage bucket  
reference to the bucket:  

Configuring backend for Terraform state files to be saved remotely. In this case it's manually made storage bucket in GCP.  
The bucket is then referenced in Terraform project in `./versions.tf:20-23`