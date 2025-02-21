#!/bin/bash

STACK_NAME="backend-api"

# Path to the environment variables file
COMPOSE_FILE="../gpmd-backend/backend-api-swarm.yml"


# Set variables for Azure ACR credentials
ACR_URL="dccontainer.azurecr.io"
ACR_USERNAME="DcContainer"
ACR_PASSWORD="zh2puYwcUdjI+ye4e76ki7KPU+B3F4WULtBmQTWO5M+ACRDyTuVo"

# Login to Azure Container Registry
echo "🔐 Logging into Azure Container Registry..."
echo "$ACR_PASSWORD" | docker login "$ACR_URL" -u "$ACR_USERNAME" --password-stdin

# Deploy the custom stack with Response API image
echo "🚀 Deploying Response API with custom image..."
docker stack deploy -c "$COMPOSE_FILE" "$STACK_NAME" --prune --resolve-image always

# Wait for services to be ready
echo "⌛ Waiting for Response API service to be ready..."
sleep 10

# Check the Response API service status
echo "📡 Checking Response API service status..."
docker service ls | grep "$STACK_NAME"

# Display Response API access details
NODE_IP=$(docker node inspect self --format "{{ .Status.Addr }}")
echo "✅ Response API Deployed Successfully!"
echo "📌 Response API: http://$NODE_IP:8081"  # Port based on expose
