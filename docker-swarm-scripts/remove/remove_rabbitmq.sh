#!/bin/bash

# Stack Name
STACK_NAME="rabbitmq"

# Remove RabbitMQ stack from Docker Swarm
echo "🧹 Removing RabbitMQ stack..."
docker stack rm "$STACK_NAME"

# Wait for the stack removal to complete
echo "⌛ Waiting for RabbitMQ stack removal..."
sleep 5

# Check if RabbitMQ stack has been removed
docker stack ls | grep "$STACK_NAME" &> /dev/null

if [ $? -eq 0 ]; then
    echo "⚠️ Failed to remove RabbitMQ stack."
else
    echo "✅ RabbitMQ stack removed successfully."
fi
