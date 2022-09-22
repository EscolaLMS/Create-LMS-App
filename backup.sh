#!/bin/bash
. .env

POSTGRES_DB=postgresql://$DB_USERNAME:$DB_PASSWORD@127.0.0.1:$DB_PORT/$DB_DATABASE
NOW_DB_PREFIX=$(date +\%Y-\%m-\%d-\%H:\%M:\%S)

docker-compose --env-file .env  exec -T postgres bash -c "pg_dump --clean --dbname=${POSTGRES_DB} -f /var/lib/postgresql/backups/backup-${NOW_DB_PREFIX}.sql"	
docker-compose --env-file .env  exec -T postgres bash -c "cp /var/lib/postgresql/backups/backup-${NOW_DB_PREFIX}.sql  /var/lib/postgresql/backups/backup-latest.sql"