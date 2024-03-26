#!/bin/bash

DIRECTORY="docker/postgres-data"

if [ -d "$DIRECTORY" ]; then
  echo "$DIRECTORY does exist. Exiting"
  echo "To create new credentials run 'make refresh', but beware as this is destructive action"
  echo "To restart run 'make restart'"
  exit 1
fi

# generate random secure passwords
DB_PASSWORD=$(openssl rand -hex 12);
REDIS_PASSWORD=$(openssl rand -hex 12);
AWS_SECRET_ACCESS_KEY=$(openssl rand -hex 12);

# generated 
APP_URL="${APP_URL:-http://api.wellms.localhost}"  
ADMIN_URL="${ADMIN_URL:-http://admin.wellms.localhost}"  
FRONT_URL="${FRONT_URL:-http://app.wellms.localhost}"  
MAILHOG_URL="${MAILHOG_URL:-http://mailhog.wellms.localhost}"  
REPORTBRO_URL="${REPORTBRO_URL:-http://reportbro.wellms.localhost}"  
STORAGE_URL="${STORAGE_URL:-http://storage.wellms.localhost}"  
MINIO_URL="${MINIO_URL:-http://minio.wellms.localhost}"  


# fetch just domain from URLs 
FRONT_URL_DOMAIN="$(echo "$FRONT_URL" | awk -F/ '{print $3}')"
ADMIN_URL_DOMAIN="$(echo "$ADMIN_URL" | awk -F/ '{print $3}')"
APP_URL_DOMAIN="$(echo "$APP_URL" | awk -F/ '{print $3}')"
MAILHOG_URL_DOMAIN="$(echo "$MAILHOG_URL" | awk -F/ '{print $3}')"
REPORTBRO_URL_DOMAIN="$(echo "$REPORTBRO_URL" | awk -F/ '{print $3}')"
STORAGE_URL_DOMAIN="$(echo "$STORAGE_URL" | awk -F/ '{print $3}')"
MINIO_URL_DOMAIN="$(echo "$MINIO_URL" | awk -F/ '{print $3}')"

# create tmp yaml file to work on 
# cp templates/docker-compose.yml.tpl templates/docker-compose.yml.tpl.tmp
# YAML=$(docker run -i --rm mikefarah/yq eval '.services.postgres.environment[2] = "POSTGRES_PASSWORD='${DB_PASSWORD}'"' < templates/docker-compose.yml.tpl.tmp)
# echo "$YAML" > templates/docker-compose.yml.tpl.tmp
# YAML=$(docker run -i --rm mikefarah/yq eval '.services.redis.command = "redis-server --requirepass '${REDIS_PASSWORD}'"' < templates/docker-compose.yml.tpl.tmp)
# echo "$YAML" > templates/docker-compose.yml.tpl.tmp
# YAML=$(docker run -i --rm mikefarah/yq eval '.services.app.environment[0] = "API_URL='${APP_URL}'"' < templates/docker-compose.yml.tpl.tmp)
# echo "$YAML" > templates/docker-compose.yml.tpl.tmp
# YAML=$(docker run -i --rm mikefarah/yq eval '.services.admin.environment[0] = "API_URL='${APP_URL}'"' < templates/docker-compose.yml.tpl.tmp)
# echo "$YAML" > templates/docker-compose.yml.tpl.tmp

# Remove previous files if the exists
# rm -f docker-compose.yml .env templates/docker-compose.yml.tpl.tmp

# save values to files
eval "cat <<< \"$(<templates/.env.tpl)\"" > .env

## TODO if domain is local use tls self_signed in caddy
eval "cat <<< \"$(<templates/Caddyfile.http.tpl)\"" > Caddyfile

cp templates/docker-compose.yml.tpl docker-compose.yml

#echo "$YAML" > docker-compose.yml

