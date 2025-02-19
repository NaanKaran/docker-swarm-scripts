#!/bin/bash

STACK_NAME="functions"

echo "Removing functions..."
docker stack rm $STACK_NAME

sleep 5
docker service ls | grep $STACK_NAME || echo "functions removed successfully!"

