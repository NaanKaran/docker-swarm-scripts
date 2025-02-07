#!/bin/bash

STACK_NAME="backend-api"

echo "Removing Backend--Api..."
docker stack rm $STACK_NAME

sleep 5
docker service ls | grep $STACK_NAME || echo "Backend--Apis removed successfully!"

