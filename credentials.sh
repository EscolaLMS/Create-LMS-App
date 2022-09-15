#!/bin/bash

# generate random secure passwords
DBPASS_RND=$(openssl rand -base64 12);
REDISPASS_RND=$(openssl rand -base64 12);

# generated 
API_URL="${API_URL:-http://api.wellms.localhost}"  
ADMIN_URL="${ADMIN_URL:-http://admin.wellms.localhost}"  
APP_URL="${APP_URL:-http://app.wellms.localhost}"  
MAILHOG_URL="${MAILHOG_URL:-http://mailhog.wellms.localhost}"  

API_URL_DOMAIN="$(echo "$API_URL" | awk -F/ '{print $3}')"
ADMIN_URL_DOMAIN="$(echo "$ADMIN_URL" | awk -F/ '{print $3}')"
APP_URL_DOMAIN="$(echo "$APP_URL" | awk -F/ '{print $3}')"
MAILHOG_URL_DOMAIN="$(echo "$MAILHOG_URL" | awk -F/ '{print $3}')"


# create tmp yaml file 
cp docker-compose.yml.tpl docker-compose.yml.tpl.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.services.postgres.environment[2] = "POSTGRES_PASSWORD='${DBPASS_RND}'"' < docker-compose.yml.tpl.tmp)
echo "$YAML" > docker-compose.yml.tpl.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.services.redis.command = "redis-server --requirepass '${REDISPASS_RND}'"' < docker-compose.yml.tpl.tmp)
echo "$YAML" > docker-compose.yml.tpl.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.services.app.environment[0] = "API_URL='${API_URL}'"' < docker-compose.yml.tpl.tmp)
echo "$YAML" > docker-compose.yml.tpl.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.services.admin.environment[0] = "API_URL='${API_URL}'"' < docker-compose.yml.tpl.tmp)
echo "$YAML" > docker-compose.yml.tpl.tmp


# Remove previous files if the exists
rm -f docker-compose.yml .env docker-compose.yml.tpl.tmp

# save values to files
eval "cat <<< \"$(<.env.tpl)\"" > .env
eval "cat <<< \"$(<Caddyfile.tpl)\"" > Caddyfile

echo "$YAML" > docker-compose.yml

