POSTGRES_STACK="postgres"

echo "Removing Postgres..."
docker stack rm $POSTGRES_STACK

sleep 5
docker service ls | grep $POSTGRES_STACK || echo "Postgres removed successfully!"
