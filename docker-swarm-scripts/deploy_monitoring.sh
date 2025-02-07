#!/bin/bash

# Stack Name
STACK_NAME="monitoring"

# Swarm file name
SWARM_FILE="../monitoring/grafana-prometheus-loki-swarm.yml"

# Deploy Grafana, Prometheus, and Loki stack to Docker Swarm
echo "🚀 Deploying Grafana, Prometheus, and Loki stack..."

docker stack deploy -c $SWARM_FILE $STACK_NAME

# Wait for Grafana, Prometheus, and Loki services to start
echo "⌛ Waiting for Grafana, Prometheus, and Loki services to be ready..."
sleep 10

# Check Grafana, Prometheus, and Loki service status
echo "📡 Checking Grafana, Prometheus, and Loki service status..."
docker service ls | grep "$STACK_NAME"

# Display Grafana, Prometheus, and Loki access details
NODE_IP=$(docker node inspect self --format "{{ .Status.Addr }}")
echo "✅ Grafana, Prometheus, and Loki Deployed Successfully!"
echo "📌 Grafana: http://$NODE_IP:3000"
echo "📌 Prometheus"
echo "  📡 Prometheus: http://$NODE_IP:9090"
echo "  📡 AlertManager: http://$NODE_IP:9093"
echo "📌 Loki"
echo "  📡 Loki: http://$NODE_IP:3100"