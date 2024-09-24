#!/bin/bash

# Export environment variables
export TF_VAR_environment="hml"
export TF_VAR_project_id="ollama-lab"
export TF_VAR_region="us-central1"
export TF_VAR_zone="us-central1-a"
export TF_VAR_service_name="ollama"
export GOOGLE_APPLICATION_CREDENTIALS="/home/leo/keys/ollama-lab-2d397b0f2e3f.json"
# Navigate to the Terraform configuration directory
cd terraform

# Initialize Terraform
terraform init -backend-config="bucket=${TF_VAR_project_id}-tfstate" -backend-config="prefix=${TF_VAR_service_name}/${TF_VAR_environment}" -reconfigure 


# Apply the Terraform configuration
if [ "$1" == "apply" ]; then
  terraform apply -auto-approve
fi

# Destroy the Terraform configuration
if [ "$1" == "destroy" ]; then
  terraform destroy -auto-approve
fi
