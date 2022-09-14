#!/bin/sh

DBPASS_RND=$(openssl rand -base64 12);
REDISPASS_RND=$(openssl rand -base64 12);

eval "cat <<< \"$(<.env.tpl)\"" > .env

DBPASS_RND=$(openssl rand -base64 12);
REDISPASS_RND=$(openssl rand -base64 12);
cp docker-compose.yml.tpl docker-compose.yml.tpl.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.services.postgres.environment[2] = "POSTGRES_PASSWORD='${DBPASS_RND}'"' < docker-compose.yml.tpl.tmp)
echo "$YAML" > docker-compose.yml.tpl.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.services.redis.command = "redis-server --requirepass '${REDISPASS_RND}'"' < docker-compose.yml.tpl.tmp)

rm -f docker-compose.yml .env docker-compose.yml.tpl.tmp
echo "$YAML" > docker-compose.yml
