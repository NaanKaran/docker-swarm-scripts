STACK_NAME=nginx

COMPOSE_FILE="../nginx/nginx.yml"

echo "🔄 Deploying Nginx stack..."

# Deploy the Nginx stack
docker stack deploy -c $COMPOSE_FILE $STACK_NAME

echo "✅ Nginx stack deployed successfully."
echo "📌 Nginx is running on port 80."

