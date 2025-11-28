#!/bin/bash

set -e

echo " Starting stress test..."

# Get Load Balancer IP
LB_IP=$(kubectl get service webapp-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

if [ -z "$LB_IP" ]; then
    echo " Could not get Load Balancer IP"
    exit 1
fi

echo " Target URL: http://$LB_IP/cpu-load"

# Initial state
echo " Initial pod status:"
kubectl get pods -l app=webapp

echo " Initial HPA status:"
kubectl get hpa

# Generate load
echo " Generating CPU load..."
for i in {1..50}; do
    curl -s "http://$LB_IP/cpu-load" > /dev/null &
    sleep 0.1
done

# Monitor for 5 minutes
echo " Monitoring for 5 minutes..."
for i in {1..10}; do
    echo "--- Minute $i ---"
    kubectl get pods -l app=webapp
    kubectl get hpa
    sleep 30
done

# Stop load
echo " Stopping load..."
curl -s "http://$LB_IP/cpu-normal" > /dev/null

echo " Final status:"
kubectl get pods -l app=webapp
kubectl get hpa

echo " Stress test completed!"