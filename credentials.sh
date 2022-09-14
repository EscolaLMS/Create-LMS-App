#!/bin/bash

# generate random secure passwords
DBPASS_RND=$(openssl rand -base64 12);
REDISPASS_RND=$(openssl rand -base64 12);

# create tmp yaml file 
cp docker-compose.yml.tpl docker-compose.yml.tpl.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.services.postgres.environment[2] = "POSTGRES_PASSWORD='${DBPASS_RND}'"' < docker-compose.yml.tpl.tmp)
echo "$YAML" > docker-compose.yml.tpl.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.services.redis.command = "redis-server --requirepass '${REDISPASS_RND}'"' < docker-compose.yml.tpl.tmp)
echo "$YAML" > docker-compose.yml.tpl.tmp

# Remove previous files if the exists
rm -f docker-compose.yml .env docker-compose.yml.tpl.tmp

# save values to files
eval "cat <<< \"$(<.env.tpl)\"" > .env
echo "$YAML" > docker-compose.yml
