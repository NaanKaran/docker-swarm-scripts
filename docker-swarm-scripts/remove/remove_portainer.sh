#!/bin/bash

PORTAINER_STACK="portainer"

echo "Removing Portainer..."
docker stack rm $PORTAINER_STACK

sleep 5
docker service ls | grep $PORTAINER_STACK || echo "Portainer removed successfully!"
