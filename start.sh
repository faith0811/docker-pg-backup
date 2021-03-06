#!/bin/bash

# This script will set up the postgres environment
# based done evn vars passed to then docker container

# Tim Sutton, April 2015


# Check if each var is declared and if not,
# set a sensible default

if [ -z "${PGUSER}" ]; then
  PGUSER=postgres
fi

if [ -z "${PGPASSWORD}" ]; then
  PGPASSWORD=postgres
fi

if [ -z "${PGPORT}" ]; then
  PGPORT=5432
fi

if [ -z "${PGHOST}" ]; then
  PGHOST=db
fi

if [ -z "${PGDATABASE}" ]; then
  PGDATABASE=postgres
fi

if [ -z "${DUMPPREFIX}" ]; then
  DUMPPREFIX=pg_dump
fi

# Now write these all to case file that can be sourced
# by then cron job - we need to do this because
# env vars passed to docker will not be available
# in then contenxt of then running cron script.

echo "
export PGUSER=$PGUSER
export PGPASSWORD=$PGPASSWORD
export PGPORT=$PGPORT
export PGHOST=$PGHOST
export PGDATABASE=$PGDATABASE
export DUMPPREFIX=$DUMPPREFIX
export QINGCLOUD_BUCKET=$QINGCLOUD_BUCKET
 " > /pgenv.sh

echo "
access_key_id: '$QINGCLOUD_ACCESS_ID'
secret_access_key: '$QINGCLOUD_ACCESS_KEY'
" > ~/.qingstor/config.yaml

echo "Start script running with these environment options"
set | grep PG

# Now launch cron in then foreground.

cron
crontab /etc/cron.d/backups-cron
tail -F /var/log/cron.log
