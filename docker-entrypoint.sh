#!/bin/sh
if [ -z "${AUTHORIZED_KEYS}" ]; then
  echo "Need an ssh public key as AUTHORIZED_KEYS env variable for remote tunneling for user tunuser to port 2022. Abnormal exit ..."
  exit 1
fi

echo "Populating /home/tunuser/.ssh/authorized_keys with the value from AUTHORIZED_KEYS env variable ..."
echo "${AUTHORIZED_KEYS}" > /home/tunuser/.ssh/authorized_keys

if [ -n "${AUTHORIZED_ROOT_KEYS}" ]; then
  echo "[WARNING] found AUTHORIZED_ROOT_KEYS env variable and populating /root/.ssh/authorized_keys"
  echo "[WARNING] please only use AUTHORIZED_ROOT_KEYS when testing and remove before normal use to improve security"
  echo "${AUTHORIZED_KEYS}" > /root/.ssh/authorized_keys
fi

# Execute the CMD from the Dockerfile:
exec "$@"

