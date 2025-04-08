FROM steamcmd/steamcmd:debian

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

# COPY config_gameplay.txt $CONFIGS/config_gameplay.txt
# COPY config_remoteadmin.txt $CONFIGS/config_remoteadmin.txt
# COPY config_localadmin_global.txt $CONFIGS/../config_localadmin_global.txt
# COPY localadmin_internal_data.json $CONFIGS/../localadmin_internal_data.json

# Create steam user and group
RUN groupadd --gid $GID steam && \
    useradd --create-home -c 'Steam User' -l --uid $UID --gid $GID --home-dir $INSTALL_DIR steam && \
    chown -R steam:steam ${INSTALL_DIR} ${SERVER_DIR} ${CONFIG_DIR} && \
    chmod 777 ${INSTALL_DIR} ${SERVER_DIR} ${CONFIG_DIR}

# Copy and prepare start script
COPY start.sh $INSTALL_DIR/start.sh
RUN chmod +x ${INSTALL_DIR}/start.sh && \
    chown -R steam:steam ${INSTALL_DIR}/start.sh

# Switch to steam user
USER steam
WORKDIR $INSTALL_DIR

# Set HOME environment variable to INSTALL_DIR to force steamcmd to use it
ENV HOME=$INSTALL_DIR

ENTRYPOINT ["/bin/sh", "start.sh"]