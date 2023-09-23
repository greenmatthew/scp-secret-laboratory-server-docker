echo "Current user is: $(whoami)"
steamcmd +force_install_dir $SERVER +login anonymous +app_update 996560 validate +quit

chown steam:steam -R $HOME_DIR

su - steam
echo "Current user is: $(whoami)"
cd $SERVER
export HOME=$HOME_DIR
./LocalAdmin $PORT --config $CONFIGS
