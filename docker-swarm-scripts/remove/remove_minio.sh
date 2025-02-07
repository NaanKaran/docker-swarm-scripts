# Stack Name
MINIO_STACK_NAME="minio"

echo "Removing minio..."
docker stack rm $MINIO_STACK_NAME

sleep 5

docker service ls | grep $MINIO_STACK_NAME || echo "Minio removed successfully!"