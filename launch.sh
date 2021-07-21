#!/bin/bash

# Save the variables so TF can recognize inputs
export TF_VAR_PROJECT=$(gcloud config get-value project)
export TF_VAR_REGION="us-central1"
export PROJECT_ID=$(gcloud config get-value project)
export serviceAccount="tfe-deployment-sa@"$PROJECT_ID".iam.gserviceaccount.com"

# Install Terraform
sudo gsutil cp gs://tfe-resources/wget /usr/bin/wget
sudo gsutil cp gs://tfe-resources/unzip /usr/bin/unzip
sudo chmod 755 /usr/bin/unzip
sudo chmod 755 /usr/bin/wget
sudo wget https://releases.hashicorp.com/terraform/1.0.2/terraform_1.0.2_linux_amd64.zip
sudo unzip terraform_1.0.2_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Terraform Apply & Run
cd terraform
terraform init
terraform plan -out="/tmp/plan.out"
terraform apply -auto-approve "/tmp/plan.out"
terraform show