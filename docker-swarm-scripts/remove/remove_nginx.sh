#!/bin/bash

nginx_STACK="nginx"

echo "Removing nginx..."
docker stack rm $nginx_STACK

sleep 5
docker service ls | grep $nginx_STACK || echo "nginx removed successfully!"