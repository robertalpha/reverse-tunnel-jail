#!/bin/sh
if [ -z "${AUTHORIZED_KEYS}" ]; then
  echo "Need an ssh public key as AUTHORIZED_KEYS env variable for remote tunneling for user tunuser. Abnormal exit ..."
  exit 1
fi

echo "Populating /home/tunuser/.ssh/authorized_keys with the value from AUTHORIZED_KEYS env variable ..."
echo "${AUTHORIZED_KEYS}" > /home/tunuser/.ssh/authorized_keys

if [ -n "${OPEN_PORTS}" ]; then
  echo "overriding permitted ports to include: ${OPEN_PORTS}"
  PORT_STRING=$(echo "$OPEN_PORTS" | sed -r 's/,/\\ /g')
  sed -i "s/PermitListen\ 2022/PermitListen\ $PORT_STRING/g" /etc/ssh/sshd_config
fi

CONTAINER_INTERNAL_IP=$(/sbin/ip route|awk '/src/ { print $7 }')

echo "Running. To test setup run (replace 2022 if you're using OPEN_PORTS):"
echo " ssh -TN -R \*:2022:localhost:8022  tunuser@$CONTAINER_INTERNAL_IP"
echo "this tunnels you hosts port 8022 to the container's port 2022"
echo "if you have a webserver running on 8022, then next try:"
echo " curl $CONTAINER_INTERNAL_IP:2022"

# Execute the CMD from the Dockerfile:
exec "$@"

