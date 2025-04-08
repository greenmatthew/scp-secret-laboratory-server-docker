FROM steamcmd/steamcmd:latest

ENV PORT=7777
ENV UID=1000
ENV GID=1000
# ENV HOME_DIR=/home/steam
# ENV SERVER=$HOME_DIR/server
# ENV CONFIGS=$HOME_DIR/.config/SCP\ Secret\ Laboratory/config/$PORT
ENV STEAM_DIR=/usr/lib/games/steam
ENV INSTALL_DIR=/home/steam
ENV SERVER_DIR=$INSTALL_DIR/server
ENV CONFIG_DIR=$INSTALL_DIR/.config

RUN mkdir -p ${INSTALL_DIR} ${SERVER_DIR} ${CONFIG_DIR}

RUN apt-get update && \
    apt-get install -y libicu-dev

# Create a new group and user using groupadd/useradd instead of addgroup/adduser
RUN groupadd --gid $GID steam && \
    useradd --disabled-password --gecos '' --uid $UID --gid $GID steam

COPY start.sh $INSTALL_DIR/start.sh
# COPY config_gameplay.txt $CONFIGS/config_gameplay.txt
# COPY config_remoteadmin.txt $CONFIGS/config_remoteadmin.txt
# COPY config_localadmin_global.txt $CONFIGS/../config_localadmin_global.txt
# COPY localadmin_internal_data.json $CONFIGS/../localadmin_internal_data.json

# Change ownership of directories and set the start script as executable
RUN chown $UID:$GID -R ${STEAM_DIR} ${INSTALL_DIR} ${SERVER_DIR} ${CONFIG_DIR} && \
    chmod +x ${INSTALL_DIR}/start.sh

ENTRYPOINT /bin/sh ${INSTALL_DIR}/start.sh