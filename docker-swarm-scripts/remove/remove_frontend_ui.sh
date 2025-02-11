#!/bin/bash

STACK_NAME="frontend-ui"


echo "Removing Frontend-UI..."

docker stack rm $STACK_NAME

sleep 5
docker service ls | grep $STACK_NAME || echo "Frontend-UI removed successfully!"
```