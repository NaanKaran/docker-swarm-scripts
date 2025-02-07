#!/bin/bash

STACK_NAME=redis-stack

COMPOSE_FILE="../redis/redis-swarm.yml"

echo "🔄 Deploying Redis stack..."

# Deploy the Redis stack
docker stack deploy -c $COMPOSE_FILE $STACK_NAME

echo "✅ Redis stack deployed successfully."
echo "📌 Redis is running on port 6379."
