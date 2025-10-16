#!/bin/bash

echo "🚀 Deploying Pinecone..."

Pinecone_Stack="pinecone"
pinecone_file="../pine-cone/pinecone-swarm.yml"

echo "Deploying Pinecone..."
docker stack deploy -c $pinecone_file $Pinecone_Stack

sleep 5
docker service ls | grep $Pinecone_Stack

echo "✅ Pinecone Deployed Successfully!"
