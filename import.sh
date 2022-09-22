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
BACKUP_FILE="${BACKUP_FILE:-backup-solid.sql}"  

docker-compose --env-file .env  exec postgres bash -c "psql --dbname=${POSTGRES_DB} < /var/lib/postgresql/backups/${BACKUP_FILE}"

echo "Backup create at backups/${BACKUP_FILE}"

