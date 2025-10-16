MONGO_STACK="mongo"
CLICKHOUSE_STACK="clickhouse"

echo "Removing ClickHouse..."
docker stack rm $CLICKHOUSE_STACK

sleep 5
docker service ls | grep $CLICKHOUSE_STACK || echo "ClickHouse removed successfully!"
