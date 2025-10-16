#!/bin/bash

echo "🚀 Deploying Postgres..."

POSTGRES_STACK="postgres"
postgres_swarm_file="../postgres/postgres-swarm.yml"

echo "Deploying PostGres..."
docker stack deploy -c $postgres_swarm_file $POSTGRES_STACK

sleep 5
docker service ls | grep $POSTGRES_STACK
