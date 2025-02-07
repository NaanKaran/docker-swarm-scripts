#!/bin/bash

PORTAINER_STACK="portainer"
yaml_file="../portnainer/portainer-agent-stack.yml"

echo "Deploying Portainer..."
docker stack deploy -c $yaml_file $PORTAINER_STACK

sleep 5
docker service ls | grep $PORTAINER_STACK
