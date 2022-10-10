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

cp tpls/namespace.yaml.tpl namespace.yaml
cp tpls/configmap.yaml.tpl configmap.yaml
cp tpls/deploy-admin.yaml.tpl deploy-admin.yaml
cp tpls/deploy-backend.yaml.tpl deploy-backend.yaml
cp tpls/deploy-frontend.yaml.tpl deploy-frontend.yaml
cp tpls/deploy-mailhog.yaml.tpl deploy-mailhog.yaml
cp tpls/deploy-postgres.yaml.tpl deploy-postgres.yaml
cp tpls/deploy-redis.yaml.tpl deploy-redis.yaml
cp tpls/deploy-scheduler-queue.yaml.tpl deploy-scheduler-queue.yaml
cp tpls/ingress.yaml.tpl ingress.yaml
cp tpls/volume-backend.yaml.tpl volume-backend.yaml


# FILE k8s/configmap.yaml

cp tpls/configmap.yaml.tpl tmp/configmap.yaml.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.data.POSTGRES_PASSWORD="'${DB_PASSWORD}'"' < tmp/configmap.yaml.tmp)
echo "$YAML" > tmp/configmap.yaml.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.data.API_URL="'${APP_URL}'"' < tmp/configmap.yaml.tmp)
echo "$YAML" > tmp/configmap.yaml.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.data.LARAVEL_APP_URL="'${APP_URL}'"' < tmp/configmap.yaml.tmp)
echo "$YAML" > tmp/configmap.yaml.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.data.LARAVEL_DB_PASSWORD="'${DB_PASSWORD}'"' < tmp/configmap.yaml.tmp)
echo "$YAML" > tmp/configmap.yaml.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.data.LARAVEL_REDIS_PASSWORD="'${REDIS_PASSWORD}'"' < tmp/configmap.yaml.tmp)
echo "$YAML" > tmp/configmap.yaml.tmp

rm -f  tmp/configmap.yaml.tmp

echo "$YAML" > configmap.yaml

# FILE k8s/ingress.yaml

cp tpls/ingress.yaml.tpl tmp/ingress.yaml.tmp

YAML=$(docker run -i --rm mikefarah/yq eval '.spec.rules[0].host="'${APP_URL_DOMAIN}'"' < tmp/ingress.yaml.tmp)
echo "$YAML" > tmp/ingress.yaml.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.spec.rules[1].host="'${FRONT_URL_DOMAIN}'"' < tmp/ingress.yaml.tmp)
echo "$YAML" > tmp/ingress.yaml.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.spec.rules[2].host="'${ADMIN_URL_DOMAIN}'"' < tmp/ingress.yaml.tmp)
echo "$YAML" > tmp/ingress.yaml.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.spec.rules[3].host="'${MAILHOG_URL_DOMAIN}'"' < tmp/ingress.yaml.tmp)
echo "$YAML" > tmp/ingress.yaml.tmp
rm -f  tmp/ingress.yaml.tmp

echo "$YAML" > ingress.yaml

