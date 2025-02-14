#!/bin/bash

MONGO_STACK="mongo"
mongo_swarm_file="../mongodb/mongo-swarm.yml"

echo "Deploying MongoDB..."
docker stack deploy -c $mongo_swarm_file $MONGO_STACK

sleep 5
docker service ls | grep $MONGO_STACK
