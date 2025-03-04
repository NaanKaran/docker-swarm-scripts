#!/bin/bash

# Configuration variables
STACK_NAME="vault"                     # Replace with your stack name if different
SERVICE_NAME="${STACK_NAME}_vault"           # Matches the service name in your docker-compose.yml
VAULT_ADDR="http://127.0.0.1:8200"           # Localhost if running on the host; adjust if needed
TRANSIT_MOUNT_PATH="transit"
TRANSIT_KEY_NAME="autounseal"
TOKEN_FILE="vault_transit_token.txt"         # Where the transit token will be saved

# Function to check if Vault is healthy
wait_for_vault() {
  echo "Waiting for Vault to become available..."
  until curl -s "$VAULT_ADDR/v1/sys/health" > /dev/null 2>&1; do
    echo "Vault not yet available, waiting 5 seconds..."
    sleep 5
  done
  echo "Vault is available!"
}

# Function to get the container ID of the Vault service
get_container_id() {
  CONTAINER_ID=$(docker ps -q -f "label=com.docker.swarm.service.name=$SERVICE_NAME")
  if [ -z "$CONTAINER_ID" ]; then
    echo "Error: Could not find Vault container for service $SERVICE_NAME"
    exit 1
  fi
  echo "Found Vault container: $CONTAINER_ID"
}

# Function to execute commands inside the Vault container
vault_exec() {
  docker exec "$CONTAINER_ID" vault "$@"
}

# Function to check Vault's initialization status
check_vault_status() {
  HEALTH_CHECK=$(curl -s "$VAULT_ADDR/v1/sys/health" -w "%{http_code}" -o /tmp/vault_health.json)
  STATUS_CODE=$(echo "$HEALTH_CHECK" | tail -n1)
  
  if [ "$STATUS_CODE" -eq 200 ]; then
    echo "Vault is initialized and unsealed."
    INITIALIZED=true
    SEALED=false
  elif [ "$STATUS_CODE" -eq 429 ]; then
    echo "Vault is initialized but sealed."
    INITIALIZED=true
    SEALED=true
  elif [ "$STATUS_CODE" -eq 501 ]; then
    echo "Vault is not initialized."
    INITIALIZED=false
    SEALED=false
  else
    echo "Unexpected Vault health status: $STATUS_CODE"
    cat /tmp/vault_health.json
    exit 1
  fi
}

# Main script
echo "Starting Vault transit backend setup..."

# Step 1: Wait for Vault to be ready
wait_for_vault

# Step 2: Get the Vault container ID
get_container_id

# Step 3: Check Vault status
check_vault_status

if [ "$INITIALIZED" = "false" ]; then
  echo "Initializing Vault..."
  INIT_OUTPUT=$(vault_exec operator init -key-shares=1 -key-threshold=1)
  if [ $? -ne 0 ]; then
    echo "Error: Vault initialization failed"
    echo "$INIT_OUTPUT"
    exit 1
  fi

  # Extract unseal key and root token
  UNSEAL_KEY=$(echo "$INIT_OUTPUT" | grep "Unseal Key 1" | awk '{print $4}')
  ROOT_TOKEN=$(echo "$INIT_OUTPUT" | grep "Initial Root Token" | awk '{print $4}')

  if [ -z "$UNSEAL_KEY" ] || [ -z "$ROOT_TOKEN" ]; then
    echo "Error: Could not extract unseal key or root token"
    echo "$INIT_OUTPUT"
    exit 1
  fi

  echo "Vault initialized. Unseal Key: $UNSEAL_KEY, Root Token: $ROOT_TOKEN"

  # Step 4: Unseal Vault
  echo "Unsealing Vault..."
  vault_exec operator unseal "$UNSEAL_KEY"
  if [ $? -ne 0 ]; then
    echo "Error: Vault unseal failed"
    exit 1
  fi
elif [ "$INITIALIZED" = "true" ] && [ "$SEALED" = "true" ]; then
  echo "Vault is initialized but sealed. Please provide an unseal key."
  read -p "Enter Unseal Key: " UNSEAL_KEY
  echo "Unsealing Vault..."
  vault_exec operator unseal "$UNSEAL_KEY"
  if [ $? -ne 0 ]; then
    echo "Error: Vault unseal failed"
    exit 1
  fi
  echo "Vault unsealed successfully."
else
  echo "Vault is already initialized and unsealed."
fi

# Step 5: Log in (prompt for root token if not already set)
if [ -z "$ROOT_TOKEN" ]; then
  echo "Please provide the root token to log in."
  read -p "Enter Root Token: " ROOT_TOKEN
fi
echo "Logging in to Vault..."
vault_exec login "$ROOT_TOKEN"
if [ $? -ne 0 ]; then
  echo "Error: Vault login failed"
  exit 1
fi

# Step 6: Enable transit secrets engine
echo "Enabling transit secrets engine at $TRANSIT_MOUNT_PATH..."
vault_exec secrets enable -path="$TRANSIT_MOUNT_PATH" transit
if [ $? -ne 0 ]; then
  echo "Error: Failed to enable transit secrets engine (it may already be enabled)"
  # Continue even if it fails, as it might already exist
fi

# Step 7: Create the autounseal key
echo "Creating transit key $TRANSIT_KEY_NAME..."
vault_exec write -f "$TRANSIT_MOUNT_PATH/keys/$TRANSIT_KEY_NAME"
if [ $? -ne 0 ]; then
  echo "Error: Failed to create transit key (it may already exist)"
  # Continue even if it fails, as it might already exist
fi

# Step 8: Create a token for transit seal (with a simple policy)
echo "Creating a policy for transit seal..."
cat <<EOF | docker exec -i "$CONTAINER_ID" vault policy write transit-policy -
path "$TRANSIT_MOUNT_PATH/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
EOF

echo "Generating a token for transit seal..."
TRANSIT_TOKEN=$(vault_exec token create -policy=transit-policy -field=token)
if [ $? -ne 0 ]; then
  echo "Error: Failed to create transit token"
  exit 1
fi

# Save the token to a file
echo "$TRANSIT_TOKEN" > "$TOKEN_FILE"
echo "Transit token saved to $TOKEN_FILE: $TRANSIT_TOKEN"

echo "Vault transit backend setup completed successfully!"
echo "Update your vault.hcl with the token from $TOKEN_FILE and redeploy."