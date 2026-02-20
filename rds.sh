#!/bin/bash

# --- Configuration & Setup ---
CONFIG_FILE="rds.conf"
CERT_PATH="$HOME/global-bundle.pem"

# 1. Load variables from file
if [[ -f "$CONFIG_FILE" ]]; then
    echo "Reading configuration from $CONFIG_FILE..."
    source ./"$CONFIG_FILE"
else
    echo "Error: Configuration file $CONFIG_FILE not found!"
    exit 1
fi

# Download the RDS Global Bundle if it doesn't exist
if [[ ! -f "$CERT_PATH" ]]; then
    echo "Downloading RDS Global Bundle..."
    curl -s -o "$CERT_PATH" https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem
fi

# --- Step 1: Input Validation ---
if [[ -z "$RDS_ENDPOINT" || -z "$MASTER_SECRET_NAME" || -z "$IAM_ADMIN_USER" ]]; then
    echo "Error: Error: One or more variables in $CONFIG_FILE are empty."
    exit 1
fi

# --- Step 2: Retrieve Master Credentials ---
echo "Step 2: Retrieving Master Credentials from Secrets Manager..."
# Note: Using single quotes around the secret ID to prevent Bash expansion of '!'
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id "$MASTER_SECRET_NAME" --region "$REGION" --query SecretString --output text 2>/dev/null)

if [[ $? -ne 0 ]]; then
    echo "Error: Could not find secret '$MASTER_SECRET_NAME' in region '$REGION'."
    exit 1
fi

MASTER_USER=$(echo "$SECRET_JSON" | jq -r .username)
MASTER_PASS=$(echo "$SECRET_JSON" | jq -r .password)

echo "Step 3: Creating IAM Admin user '$IAM_ADMIN_USER' using Master Credentials..."
mysql -h "$RDS_ENDPOINT" -u "$MASTER_USER" -p"$MASTER_PASS" "$DB_NAME" <<EOF

CREATE USER IF NOT EXISTS '$IAM_ADMIN_USER'@'%' IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS';
ALTER USER '$IAM_ADMIN_USER'@'%' REQUIRE SSL;

GRANT CREATE USER, RELOAD, PROCESS ON *.* TO '$IAM_ADMIN_USER'@'%' WITH GRANT OPTION;

GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$IAM_ADMIN_USER'@'%';

GRANT SELECT ON mysql.* TO '$IAM_ADMIN_USER'@'%';

FLUSH PRIVILEGES;
EOF

if [[ $? -ne 0 ]]; then
    echo "Error: Master login or SQL execution failed."
    exit 1
fi

echo "Step 4: Switching to IAM Authentication for '$IAM_ADMIN_USER'..."
TOKEN=$(aws rds generate-db-auth-token --hostname "$RDS_ENDPOINT" --port 3306 --region "$REGION" --username "$IAM_ADMIN_USER")

if [[ $? -ne 0 ]]; then
    echo "Error: Could not generate IAM token."
    exit 1
fi

echo "Step 5: Creating App Users using IAM Token..."
mysql -h "$RDS_ENDPOINT" --user="$IAM_ADMIN_USER" --password="$TOKEN" --ssl-ca="$CERT_PATH" --ssl-verify-server-cert <<EOF
CREATE USER IF NOT EXISTS 'node_app'@'%' IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS';
CREATE USER IF NOT EXISTS 'node_user'@'%' IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS';

GRANT SELECT, INSERT, UPDATE, DELETE ON \`$DB_NAME\`.* TO 'node_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON \`$DB_NAME\`.* TO 'node_user'@'%';

FLUSH PRIVILEGES;
EOF

if [[ $? -eq 0 ]]; then
    echo -e "Success! All users created and managed via IAM."
else
    echo "Error: App user creation failed."
    exit 1
fi