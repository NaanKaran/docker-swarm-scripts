#!/bin/bash

# Stack Name
STACK_NAME="rabbitmq"

# RabbitMQ Swarm Compose File
COMPOSE_FILE="../rabbitmq/rabbitmq-swarm.yml"

# Deploy RabbitMQ stack
echo "🚀 Deploying RabbitMQ..."
docker stack deploy -c "$COMPOSE_FILE" "$STACK_NAME"

# Wait for RabbitMQ service to start
echo "⌛ Waiting for RabbitMQ service to be ready..."
sleep 10

# Check RabbitMQ service status
echo "📡 Checking RabbitMQ service status..."
docker service ls | grep "$STACK_NAME"

# Display RabbitMQ access details
NODE_IP=$(docker node inspect self --format "{{ .Status.Addr }}")
echo "✅ RabbitMQ Deployed Successfully!"
echo "📌 RabbitMQ Management UI: http://$NODE_IP:15672"
echo "🔑 Login: admin / secretpassword"
echo "📌 AMQP Connection: amqp://admin:secretpassword@$NODE_IP:5672/"
