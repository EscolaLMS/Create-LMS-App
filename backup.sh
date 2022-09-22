#!/bin/bash
. .env

url_encode() {
   awk 'BEGIN {
      for (n = 0; n < 125; n++) {
         m[sprintf("%c", n)] = n
      }
      n = 1
      while (1) {
         s = substr(ARGV[1], n, 1)
         if (s == "") {
            break
         }
         t = s ~ /[[:alnum:]_.!~*\47()-]/ ? t s : t sprintf("%%%02X", m[s])
         n++
      }
      print t
   }' "$1"
}

DB_PASSWORD_ESC=$(url_encode "$DB_PASSWORD")

POSTGRES_DB=postgresql://$DB_USERNAME:$DB_PASSWORD_ESC@127.0.0.1:$DB_PORT/$DB_DATABASE
NOW_DB_PREFIX=$(date +\%Y-\%m-\%d-\%H:\%M:\%S)

docker-compose --env-file .env  exec -T postgres bash -c "pg_dump --clean --dbname=${POSTGRES_DB} -f /var/lib/postgresql/backups/backup-${NOW_DB_PREFIX}.sql"	
docker-compose --env-file .env  exec -T postgres bash -c "cp /var/lib/postgresql/backups/backup-${NOW_DB_PREFIX}.sql  /var/lib/postgresql/backups/backup-latest.sql"