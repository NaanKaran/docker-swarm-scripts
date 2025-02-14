#!/bin/bash

STACK_NAME=redis-stack

echo "🗑 Removing Redis stack..."

docker stack rm $STACK_NAME

echo "✅ Redis stack removed successfully."
