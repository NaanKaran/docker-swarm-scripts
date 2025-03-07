#!/bin/bash

# Stack Name
STACK_NAME="keycloak"


#sql compose file
SQL_COMPOSE_FILE="../keycloak/sqlserver.yml"

# Keycloak Swarm Compose File
COMPOSE_FILE="../keycloak/docker-compose.yml"



# Set variables for Azure ACR credentials
ACR_URL="prodprogpmdacr.azurecr.io"
ACR_USERNAME="prodprogpmdacr"
ACR_PASSWORD="G16ThrcQUvmgNhvYMn6dsI+u000MXc6B"

# Login to Azure Container Registry
echo "🔐 Logging into Azure Container Registry..."
echo "$ACR_PASSWORD" | docker login "$ACR_URL" -u "$ACR_USERNAME" --password-stdin

#Deploy SQL
echo "🚀 Deploying SQL..."
docker stack deploy -c "$SQL_COMPOSE_FILE" "$STACK_NAME"
# sleep 10

# Deploy Keycloak stack
echo "🚀 Deploying Keycloak..."
docker stack deploy -c "$COMPOSE_FILE" "$STACK_NAME"

# Wait for Keycloak service to start
echo "⌛ Waiting for Keycloak service to be ready..."
sleep 10

# Check Keycloak service status
echo "📡 Checking Keycloak service status..."
docker service ls | grep "$STACK_NAME"

# Display Keycloak access details
NODE_IP=$(docker node inspect self --format "{{ .Status.Addr }}")
echo "✅ Keycloak Deployed Successfully!"
echo "📌 Keycloak API:     http://$NODE_IP:8080/auth"
echo "📌 Keycloak Console: http://$NODE_IP:8080/auth/admin"
echo "🔑 Login: admin / admin"
