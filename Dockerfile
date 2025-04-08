FROM steamcmd/steamcmd:debian

ENV PORT=7777
ENV INSTALL_DIR=/home/steam
ENV SERVER_DIR=${INSTALL_DIR}/server
ENV CONFIG_DIR=${INSTALL_DIR}/.config
ENV CONFIG_TEMPLATES_DIR=${INSTALL_DIR}/config-templates
# Default UID/GID that can be overridden at runtime
ENV UID=1000
ENV GID=1000

# Install dependencies
RUN apt-get update && \
    apt-get install -y libicu-dev gosu && \
    rm -rf /var/lib/apt/lists/*

# Create directories (but don't create the user yet)
RUN mkdir -p ${CONFIG_TEMPLATES_DIR}
COPY config-templates/ ${CONFIG_TEMPLATES_DIR}/

# Copy and prepare scripts
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY start.sh /start.sh
RUN chmod +x /start.sh

# User will be created at runtime based on ENV values
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]