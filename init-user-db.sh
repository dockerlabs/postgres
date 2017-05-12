#!/bin/bash
set -e

source /docker-entrypoint-initdb.d/functional

initialize_database
configure_recovery
create_database
create_replication_user

set_postgresql_param "listen_addresses" "*" quiet

case $REPLICATION_MODE in
  slave|snapshot|backup)
    pg_ctl -D "$PGDATA" -w start >/dev/null
    rm /docker-entrypoint-initdb.d/postgis.sh
    ;;
esac
