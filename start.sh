#!/bin/sh
echo "Current user is: $(whoami)"

# Install/update SCP:SL server
steamcmd +force_install_dir $SERVER_DIR +login anonymous +app_update 996560 validate +quit

# # Ensure config directory exists
CONFIGS="$INSTALL_DIR/.config/SCP Secret Laboratory/config/"
mkdir -p "$CONFIGS"
chmod 755 "$CONFIGS"

# Run server directly (no need to su)
cd $SERVER_DIR && HOME=$INSTALL_DIR ./LocalAdmin $PORT --help #--config "$CONFIGS"

sleep infinity