#!/bin/bash

terraform apply -target=google_artifact_registry_repository.gcp-poc-artifact-registry

docker push europe-west8-docker.pkg.dev/srb-du04-due-13/gcp-poc-artifact-registry/weather-data-publisher:latest
docker push europe-west8-docker.pkg.dev/srb-du04-due-13/gcp-poc-artifact-registry/weather-data:latest

terraform apply

