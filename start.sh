echo "Current user is: $(whoami)"
steamcmd +force_install_dir $SERVER_DIR +login anonymous +app_update 996560 validate +quit

chown steam:steam -R $INSTALL_DIR

su - steam
echo "Current user is: $(whoami)"
cd $SERVER_DIR
export HOME=$SERVER_DIR
./LocalAdmin $PORT --config $CONFIGS
