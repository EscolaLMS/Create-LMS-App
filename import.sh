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

PASS=$(url_encode "$DB_PASSWORD")

echo $PASS

exit 0

POSTGRES_DB=postgresql://$DB_USERNAME:$DB_PASSWORD@127.0.0.1:$DB_PORT/$DB_DATABASE
BACKUP_FILE="${BACKUP_FILE:-backup-solid.sql}"  

docker-compose --env-file .env  exec postgres bash -c "psql --dbname=${POSTGRES_DB} < /var/lib/postgresql/backups/${BACKUP_FILE}"

