#!/bin/bash

# Save the variables so TF can recognize inputs
export TF_VAR_project_id=$(gcloud config get-value project)
export TF_VAR_region="us-central1"
export TF_VAR_zone="us-central1-a"

# Enable APIs
gcloud services enable iam.googleapis.com --async
gcloud services enable cloudresourcemanager.googleapis.com --async
gcloud services enable pubsub.googleapis.com --async
gcloud services enable dataflow.googleapis.com --async
gcloud services enable bigtable.googleapis.com --async
gcloud services enable bigtableadmin.googleapis.com --async
gcloud services enable bigtabletableadmin.googleapis.com --async
gcloud services enable bigquery.googleapis.com --async

# Install Terraform
mkdir -p ~/bin
sudo wget https://releases.hashicorp.com/terraform/1.0.2/terraform_1.0.2_linux_amd64.zip -O ~/bin/terraform.zip
sudo unzip ~/bin/terraform.zip -d ~/bin
sudo mv ~/bin/terraform /usr/local/bin/



# Terraform Apply & Run
cd terraform
terraform init
terraform plan -out="/tmp/plan.out"
terraform apply -auto-approve "/tmp/plan.out"
terraform show