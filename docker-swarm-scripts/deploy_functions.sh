#!/bin/bash

STACK_NAME="functions"

# Path to the environment variables file
COMPOSE_FILE="../gpmd-functions/functions-swarm.yml"


# Set variables for Azure ACR credentials
ACR_URL="dccontainer.azurecr.io"
ACR_USERNAME="DcContainer"
ACR_PASSWORD="zh2puYwcUdjI+ye4e76ki7KPU+B3F4WULtBmQTWO5M+ACRDyTuVo"

# Login to Azure Container Registry
echo "🔐 Logging into Azure Container Registry..."
echo "$ACR_PASSWORD" | docker login "$ACR_URL" -u "$ACR_USERNAME" --password-stdin

# Deploy the custom stack with import function image
echo "🚀 Deploying functions with custom image..."
docker stack deploy -c "$COMPOSE_FILE" "$STACK_NAME" --prune --resolve-image always

# Wait for services to be ready
echo "⌛ Waiting for functions service to be ready..."
sleep 10

# Check the functions service status
echo "📡 Checking functions service status..."
docker service ls | grep "$STACK_NAME"

# Display functions access details
echo "✅ functions Deployed Successfully!"
