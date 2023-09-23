FROM steamcmd/steamcmd:latest

ENV PORT=7777
ENV UID=568
ENV GID=568
ENV HOME_DIR=/home/steam
ENV SERVER=$HOME_DIR/server
ENV CONFIGS=$HOME_DIR/.config/SCP\ Secret\ Laboratory/config/$PORT

RUN mkdir -p $HOME_DIR $SERVER

RUN apt-get update && \
    apt-get install -y libicu-dev

# Create a new group and user
RUN addgroup --gid $GID steam && \
    adduser --disabled-password --gecos '' --uid $UID --gid $GID steam

COPY start.sh /start.sh
COPY config_gameplay.txt $CONFIGS/config_gameplay.txt
COPY config_remoteadmin.txt $CONFIGS/config_remoteadmin.txt
COPY config_localadmin_global.txt $CONFIGS/../config_localadmin_global.txt
COPY localadmin_internal_data.json $CONFIGS/../localadmin_internal_data.json

# Change ownership of directories and set the start script as executable
RUN chown $UID:$GID -R $HOME_DIR /usr/lib/games/steam/

ENTRYPOINT /bin/sh /start.sh