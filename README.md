# project1
cluster creation

Pre requisites before going to invoke deployment
# Set environment variables
export PROJECT_ID="your-gcp-project-id"
gcloud config set project $PROJECT_ID

# Enable APIs
gcloud services enable container.googleapis.com compute.googleapis.com

# Configure Docker for GCR
gcloud auth configure-docker

# Build and push Docker image
docker build -t gcr.io/$PROJECT_ID/project1 .
docker push gcr.io/$PROJECT_ID/project1

# Create cluster
gcloud container clusters create project1-cluster --num-nodes=3 --machine-type=n1-standard-1

# Deploy application
kubectl create deployment project1 --image=gcr.io/$PROJECT_ID/project1
kubectl expose deployment project1 --type=LoadBalancer --port=80 --target-port=80

# Access application
gcloud compute forwarding-rules list

Application Verification:
LB_IP=$(kubectl get service webapp-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl http://$LB_IP

