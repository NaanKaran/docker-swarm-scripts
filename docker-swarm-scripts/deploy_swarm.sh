#!/bin/bash

# Detect the primary IP address
ios=$(uname)
if [[ "$ios" == "Linux" ]]; then
    IP_ADDR=$(hostname -I | awk '{print $1}')
elif [[ "$ios" == "Darwin" ]]; then
    IP_ADDR=$(ipconfig getifaddr en0)
elif [[ "$ios" == "CYGWIN"* || "$ios" == "MINGW"* ]]; then
    IP_ADDR=$(ipconfig | grep "IPv4 Address" | awk '{print $NF}' | head -n 1)
else
    echo "Unsupported OS"
    exit 1
fi

# Check if Docker is running
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed or not in PATH. Please install Docker first."
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "Docker is not running. Please start Docker first."
    exit 1
fi

# Initialize Docker Swarm
if [[ -n "$IP_ADDR" ]]; then
    echo "Initializing Docker Swarm on IP: $IP_ADDR"
    docker swarm init --advertise-addr "$IP_ADDR"
else
    echo "Could not determine IP address. Please specify manually."
    exit 1
fi
