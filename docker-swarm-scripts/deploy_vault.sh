#!/bin/bash

# Stack Name
STACK_NAME="vault"

# vault Swarm Compose File
COMPOSE_FILE="../vault/vault-swarm.yml"

# Deploy vault stack
echo "🚀 Deploying vault..."
docker stack deploy -c "$COMPOSE_FILE" "$STACK_NAME"

# Wait for vault service to start
echo "⌛ Waiting for vault service to be ready..."
sleep 10

# Check vault service status
echo "📡 Checking vault service status..."
docker service ls | grep "$STACK_NAME"

# Display vault access details
NODE_IP=$(docker node inspect self --format "{{ .Status.Addr }}")
echo "✅ vault Deployed Successfully!"
echo "📌 vault API:     http://$NODE_IP:8200"
echo "📌 vault Console: http://$NODE_IP:8201"
echo "🔑 Login: admin / secretpassword"


