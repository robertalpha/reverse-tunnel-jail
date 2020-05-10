#!/bin/sh
if [ -z "${AUTHORIZED_KEYS}" ]; then
  echo "Need an ssh public key as AUTHORIZED_KEYS env variable for remote tunneling for user tunuser. Abnormal exit ..."
  exit 1
fi

echo "Populating /home/tunuser/.ssh/authorized_keys with the value from AUTHORIZED_KEYS env variable ..."
echo "${AUTHORIZED_KEYS}" > /home/tunuser/.ssh/authorized_keys

CONTAINER_INTERNAL_IP=$(/sbin/ip route|awk '/src/ { print $7 }')

echo "Running. To test setup run:"
echo " ssh -TN -R 2022:localhost:8022  tunuser@$CONTAINER_INTERNAL_IP"
echo "this tunnels you hosts port 8022 to the container's port 2022"

# Execute the CMD from the Dockerfile:
exec "$@"

