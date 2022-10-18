#!/bin/bash
. .env

url_encode() {
    local S="${1}"
    local encoded=""
    local ch
    local o
    for i in $(seq 0 $((${#S} - 1)) )
    do
        ch=${S:$i:1}
        case "${ch}" in
            [-_.~a-zA-Z0-9]) 
                o="${ch}"
                ;;
            *) 
                o=$(printf '%%%02x' "'$ch")                
                ;;
        esac
        encoded="${encoded}${o}"
    done
    echo ${encoded}
}

DB_PASSWORD_ESC=$(url_encode "$DB_PASSWORD")

POSTGRES_DB=postgresql://$DB_USERNAME:$DB_PASSWORD_ESC@127.0.0.1:$DB_PORT/$DB_DATABASE
NOW_DB_PREFIX=$(date +\%Y-\%m-\%d-\%H:\%M:\%S)

docker-compose --env-file .env  exec -T postgres bash -c "pg_dump --clean --dbname=${POSTGRES_DB} -f /var/lib/postgresql/backups/backup-${NOW_DB_PREFIX}.sql"	
docker-compose --env-file .env  exec -T postgres bash -c "cp /var/lib/postgresql/backups/backup-${NOW_DB_PREFIX}.sql  /var/lib/postgresql/backups/backup-latest.sql"