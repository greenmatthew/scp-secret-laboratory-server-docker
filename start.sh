#!/bin/sh
set -e

echo "Current user is: $(whoami)"

# Install/update SCP:SL server
steamcmd +force_install_dir $SERVER_DIR +login anonymous +app_update 996560 validate +quit

# Ensure config directory exists
INTERNAL_CONFIG_SUBDIR="$CONFIG_DIR/SCP Secret Laboratory/config/"
mkdir -p "$INTERNAL_CONFIG_SUBDIR"

# Process the internal data template to accept EULA
INTERNAL_DATA_TEMPLATE_FILE="$CONFIG_TEMPLATES_DIR/localadmin_internal_data.json.template"
INTERNAL_DATA_FILE="$INTERNAL_CONFIG_SUBDIR/localadmin_internal_data.json"
if [ ! -f "$INTERNAL_DATA_FILE" ]; then
    echo "Creating \`localadmin_internal_data.json\` file with EULA acceptance..."
    # Get current date in the correct format
    CURRENT_DATE=$(date -u +"%Y-%m-%dT%H:%M:%S.%7NZ")
    # Replace placeholder in template
    sed "s/\${EulaDateAccepted}/$CURRENT_DATE/g" "$INTERNAL_DATA_TEMPLATE_FILE" > "$INTERNAL_DATA_FILE"
    chmod 644 "$INTERNAL_DATA_FILE"
    echo "Successfully created \`localadmin_internal_data.json\` file with EULA acceptance."
fi

# Run server
cd $SERVER_DIR && HOME=$INSTALL_DIR ./LocalAdmin $PORT --config $(CONFIG_DIR)

sleep infinity