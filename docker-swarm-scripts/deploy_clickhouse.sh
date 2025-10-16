#!/bin/bash

ClickHouse_Stack="clickhouse"
click_house_file="../click-house/clickhouse-swarm.yml"

echo "Deploying ClickHouse..."
docker stack deploy -c $click_house_file $ClickHouse_Stack

sleep 5
docker service ls | grep $ClickHouse_Stack
