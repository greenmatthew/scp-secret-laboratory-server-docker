#!/bin/sh
echo "Current user is: $(whoami)"

# Install/update SCP:SL server
steamcmd +force_install_dir $SERVER_DIR +login anonymous +app_update 996560 validate +quit

# Ensure proper ownership
chown -R steam:steam $INSTALL_DIR

# Define config directory path
CONFIGS="$INSTALL_DIR/.config/SCP Secret Laboratory/config/$PORT"

# Ensure config directory exists
mkdir -p "$CONFIGS"

# Switch to steam user and run server
su - steam -c "cd $SERVER_DIR && HOME=$INSTALL_DIR ./LocalAdmin $PORT --config \"$CONFIGS\""