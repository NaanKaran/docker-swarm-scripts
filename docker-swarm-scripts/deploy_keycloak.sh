#!/bin/bash

echo "Deploying Keycloak stack..."
docker stack deploy -c ../keycloak/keycloak-swarm.yml keycloak

echo "Keycloak stack deployed successfully!"
echo "Waiting for service to be ready..."
sleep 5

docker stack services keycloak
