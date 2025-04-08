#!/bin/sh
echo "Current user is: $(whoami)"

# Install/update SCP:SL server
steamcmd +force_install_dir $SERVER_DIR +login anonymous +app_update 996560 validate +quit

# # Define config directory path
# CONFIGS="$INSTALL_DIR/.config/SCP Secret Laboratory/config/$PORT"

# # Ensure config directory exists
# mkdir -p "$CONFIGS"

# Run server directly (no need to su)
cd $SERVER_DIR && HOME=$INSTALL_DIR ./LocalAdmin $PORT #--config "$CONFIGS"