#!/bin/bash

MONGO_STACK="mongo"

echo "Removing MongoDB..."
docker stack rm $MONGO_STACK

sleep 5
docker service ls | grep $MONGO_STACK || echo "MongoDB removed successfully!"
