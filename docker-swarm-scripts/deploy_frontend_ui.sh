#!/bin/bash

STACK_NAME="frontend-ui"

# Path to the environment variables file
COMPOSE_FILE="../gpmd-frontend/frontend-ui-swarm.yml"


# Set variables for Azure ACR credentials
ACR_URL="dccontainer.azurecr.io"
ACR_USERNAME="DcContainer"
ACR_PASSWORD="zh2puYwcUdjI+ye4e76ki7KPU+B3F4WULtBmQTWO5M+ACRDyTuVo"

# Login to Azure Container Registry
echo "🔐 Logging into Azure Container Registry..."
echo "$ACR_PASSWORD" | docker login "$ACR_URL" -u "$ACR_USERNAME" --password-stdin

# Deploy the FormBuilder UI and DashBoard UI with custom image
echo "🚀 Deploying FormBuilder UI and DashBoard UI with custom image..."
docker stack deploy -c "$COMPOSE_FILE" "$STACK_NAME" --prune --resolve-image always

# Wait for services to be ready
echo "⌛ Waiting for FormBuilder and Dashboard UI to be ready..."
sleep 10

# Check the FormBuilder and Dashboard service status
echo "📡 Checking FormBuilder and Dashboard service status..."
docker service ls | grep "$STACK_NAME"

# Display FormBuilder and Dashboard access details
NODE_IP=$(docker node inspect self --format "{{ .Status.Addr }}")
echo "✅ FormBuilder and Dashboard Deployed Successfully!"
echo "📌 FormBuilder and Dashboard: http://$NODE_IP:4000"  # Port based on expose
