#!/bin/bash

set -e

echo " Starting deployment..."

# Build and push Docker image
echo " Building Docker image..."
docker build -t gcr.io/$PROJECT_ID/webapp:latest ./app
docker push gcr.io/$PROJECT_ID/webapp:latest

# Initialize and apply Terraform
echo " Applying Terraform configuration..."
cd terraform

terraform init -upgrade
terraform plan -var="project_id=$PROJECT_ID"
terraform apply -var="project_id=$PROJECT_ID" -auto-approve

echo "Deployment completed successfully!"

# Get Load Balancer IP
LB_IP=$(terraform output -raw load_balancer_ip)
echo " Application is available at: http://$LB_IP"