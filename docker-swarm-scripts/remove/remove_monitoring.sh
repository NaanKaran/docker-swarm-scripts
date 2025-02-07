#!/bin/bash

# Stack Name
STACK_NAME="monitoring"

# Remove Grafana, Prometheus, and Loki stack from Docker Swarm
echo "🧹 Removing Grafana, Prometheus, and Loki stack... "

docker stack rm $STACK_NAME

# Wait for the stack removal to complete
echo "⌛ Waiting for Grafana, Prometheus, and Loki stack removal..."
sleep 5

# Check if Grafana, Prometheus, and Loki stack has been removed
docker stack ls | grep $STACK_NAME &> /dev/null

if [ $? -eq 0 ]; then
    echo "⚠️ Failed to remove Grafana, Prometheus, and Loki stack."
else
    echo "✅ Grafana, Prometheus, and Loki stack removed successfully."
fi
```
