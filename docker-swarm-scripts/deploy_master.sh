#!/bin/bash

echo "Initializing Docker Swarm..."
docker swarm init 2>/dev/null || echo "Swarm already initialized."

#Create Shared Network For All Services
echo "Creating shared network..."
docker network create --driver overlay --attachable shared_internal_network 2>/dev/null || echo "Network already created."

# Deploy individual services
./deploy_portainer.sh
./deploy_monitoring.sh
./deploy_rabbitmq.sh
./deploy_redis.sh
./deploy_mongo.sh
./deploy_minio.sh
./deploy_backend_api.sh
./deploy_frontend_ui.sh
./deploy_functions.sh
./deploy_nginx.sh
./deploy_vault.sh
echo "All services deployed!"
docker service ls
