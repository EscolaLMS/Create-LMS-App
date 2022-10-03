#!/bin/bash

# generate random secure passwords
DB_PASSWORD=$(openssl rand -hex 12);
REDIS_PASSWORD=$(openssl rand -hex 12);

# generated 
APP_URL="${APP_URL:-http://api.wellms.localhost}"  
ADMIN_URL="${ADMIN_URL:-http://admin.wellms.localhost}"  
FRONT_URL="${FRONT_URL:-http://app.wellms.localhost}"  
MAILHOG_URL="${MAILHOG_URL:-http://mailhog.wellms.localhost}"  

# fetch just domain from URLs 
FRONT_URL_DOMAIN="$(echo "$FRONT_URL" | awk -F/ '{print $3}')"
ADMIN_URL_DOMAIN="$(echo "$ADMIN_URL" | awk -F/ '{print $3}')"
APP_URL_DOMAIN="$(echo "$APP_URL" | awk -F/ '{print $3}')"
MAILHOG_URL_DOMAIN="$(echo "$MAILHOG_URL" | awk -F/ '{print $3}')"

# create tmp yaml file to work on 
cp docker-compose.yml.tpl docker-compose.yml.tpl.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.services.postgres.environment[2] = "POSTGRES_PASSWORD='${DB_PASSWORD}'"' < docker-compose.yml.tpl.tmp)
echo "$YAML" > docker-compose.yml.tpl.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.services.redis.command = "redis-server --requirepass '${REDIS_PASSWORD}'"' < docker-compose.yml.tpl.tmp)
echo "$YAML" > docker-compose.yml.tpl.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.services.app.environment[0] = "API_URL='${APP_URL}'"' < docker-compose.yml.tpl.tmp)
echo "$YAML" > docker-compose.yml.tpl.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.services.admin.environment[0] = "API_URL='${APP_URL}'"' < docker-compose.yml.tpl.tmp)
echo "$YAML" > docker-compose.yml.tpl.tmp

# Remove previous files if the exists
rm -f docker-compose.yml .env docker-compose.yml.tpl.tmp

# save values to files
eval "cat <<< \"$(<.env.tpl)\"" > .env

## TODO if domain is local use tls self_signed in caddy
eval "cat <<< \"$(<Caddyfile.tpl)\"" > Caddyfile

echo "$YAML" > docker-compose.yml

