#!/bin/sh
set -e

echo "Setting up container with UID:${UID} and GID:${GID}"

# Check if group with GID exists
if getent group ${GID} > /dev/null; then
  EXISTING_GROUP=$(getent group ${GID} | cut -d: -f1)
  if [ "${EXISTING_GROUP}" != "steam" ]; then
    echo "ERROR: GID ${GID} already exists with group name '${EXISTING_GROUP}'" >&2
    exit 1
  fi
else
  groupadd --gid ${GID} steam
fi

# Check if user with UID exists
if getent passwd ${UID} > /dev/null; then
  EXISTING_USER=$(getent passwd ${UID} | cut -d: -f1)
  if [ "${EXISTING_USER}" != "steam" ]; then
    echo "ERROR: UID ${UID} already exists with username '${EXISTING_USER}'" >&2
    exit 1
  fi
else
  useradd -c 'Steam User' -l --uid ${UID} --gid ${GID} --home-dir ${INSTALL_DIR} steam
fi

# Get username for the UID
USER_NAME=$(getent passwd ${UID} | cut -d: -f1)

mkdir -p ${SERVER_DIR} ${CONFIG_DIR}
# Ensure correct ownership of all directories
chown -R ${UID}:${GID} ${INSTALL_DIR} ${SERVER_DIR} ${CONFIG_TEMPLATES_DIR}
chmod -R 775 ${CONFIG_DIR}

# Now run the actual script as the specified user
exec gosu steam /start.sh