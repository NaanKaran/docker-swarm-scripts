STACK_NAME="nginx"
COMPOSE_FILE="../nginx/nginx.yml"

echo "Deploying Nginx..."

docker stack deploy -c $COMPOSE_FILE $STACK_NAME

sleep 5

docker service ls | grep $STACK_NAME || echo "Nginx deployed successfully!"