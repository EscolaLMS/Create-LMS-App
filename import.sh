#!/bin/bash
. .env

POSTGRES_DB=postgresql://$DB_USERNAME:$DB_PASSWORD@127.0.0.1:$DB_PORT/$DB_DATABASE
BACKUP_FILE="${BACKUP_FILE:-backup-solid.sql}"  

docker-compose --env-file .env  exec postgres bash -c "psql --dbname=${POSTGRES_DB} < /var/lib/postgresql/backups/${BACKUP_FILE}"

