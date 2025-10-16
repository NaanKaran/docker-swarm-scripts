#!/bin/bash

echo "Removing all services..."

./remove_portainer.sh
./remove_postgres.sh
./remove_clickhouse.sh
# ./remove_mongo.sh
# ./remove_minio.sh
# ./remove_rabbitmq.sh
# ./remove_monitoring.sh
# ./remove_redis.sh
# ./remove_backend_api.sh
# ./remove_frontend_ui.sh
# ./remove_nginx.sh

echo "All services removed!"
