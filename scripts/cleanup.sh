#!/bin/bash

set -e

echo " Cleaning up resources..."

cd terraform

terraform destroy -var="project_id=$PROJECT_ID" -auto-approve

echo " Cleanup completed!"