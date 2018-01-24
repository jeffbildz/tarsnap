#!/bin/bash

# If they requested something else, start it
if [[ ! -z "$*" ]]; then
    exec "$@"
fi

# Otherwise, let's get busy
: ${SECRET_FILE:=tarsnap_key}
: ${TARSNAPPER_CONF:=/etc/tarsnap/tarsnapper.conf}

if [[ ! -f /run/secrets/${SECRET_FILE} ]]; then
  echo "Unable to load tarsnap key from ${SECRET_FILE}."
  sleep 10
  exit 1
fi

# swap out our keyfile in the config
sed -i "/keyfile/c\keyfile /run/secrets/${SECRET_FILE}" /etc/tarsnap.conf

if [[ ! -f ${TARSNAPPER_CONF} ]]; then
  echo "No such file or directory: ${TARSNAPPER_CONF}"
  sleep 10
  exit 1
fi

# swap out our config file in the script
sed -i "/CONF/c\CONF=${TARSNAPPER_CONF}" /usr/local/bin/tarsnap.sh

# run our backups
exec /usr/local/bin/tarsnap.sh
