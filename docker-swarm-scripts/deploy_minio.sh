#!/bin/bash

# Stack Name
STACK_NAME="minio"

# MinIO Swarm Compose File
COMPOSE_FILE="../minio/minio-swarm.yml"

# Deploy MinIO stack
echo "🚀 Deploying MinIO..."
docker stack deploy -c "$COMPOSE_FILE" "$STACK_NAME"

# Wait for MinIO service to start
echo "⌛ Waiting for MinIO service to be ready..."
sleep 10

# Check MinIO service status
echo "📡 Checking MinIO service status..."
docker service ls | grep "$STACK_NAME"

# Display MinIO access details
NODE_IP=$(docker node inspect self --format "{{ .Status.Addr }}")
echo "✅ MinIO Deployed Successfully!"
echo "📌 MinIO API:     http://$NODE_IP:9002"
echo "📌 MinIO Console: http://$NODE_IP:9001"
echo "🔑 Login: admin / secretpassword"

