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

cp templates/k8s/namespace.yaml.tpl k8s/namespace.yaml
cp templates/k8s/configmap.yaml.tpl k8s/configmap.yaml
cp templates/k8s/deploy-admin.yaml.tpl k8s/deploy-admin.yaml
cp templates/k8s/deploy-backend.yaml.tpl k8s/deploy-backend.yaml
cp templates/k8s/deploy-frontend.yaml.tpl k8s/deploy-frontend.yaml
cp templates/k8s/deploy-mailhog.yaml.tpl k8s/deploy-mailhog.yaml
cp templates/k8s/deploy-postgres.yaml.tpl k8s/deploy-postgres.yaml
cp templates/k8s/deploy-redis.yaml.tpl k8s/deploy-redis.yaml
cp templates/k8s/deploy-scheduler-queue.yaml.tpl k8s/deploy-scheduler-queue.yaml
cp templates/k8s/ingress.yaml.tpl k8s/ingress.yaml
cp templates/k8s/volume-backend.yaml.tpl k8s/volume-backend.yaml


# FILE k8s/configmap.yaml

cp templates/k8s/configmap.yaml.tpl templates/tmp/configmap.yaml.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.data.POSTGRES_PASSWORD="'${DB_PASSWORD}'"' < templates/tmp/configmap.yaml.tmp)
echo "$YAML" > templates/tmp/configmap.yaml.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.data.API_URL="'${APP_URL}'"' < templates/tmp/configmap.yaml.tmp)
echo "$YAML" > templates/tmp/configmap.yaml.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.data.LARAVEL_APP_URL="'${APP_URL}'"' < templates/tmp/configmap.yaml.tmp)
echo "$YAML" > templates/tmp/configmap.yaml.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.data.LARAVEL_DB_PASSWORD="'${DB_PASSWORD}'"' < templates/tmp/configmap.yaml.tmp)
echo "$YAML" > templates/tmp/configmap.yaml.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.data.LARAVEL_REDIS_PASSWORD="'${REDIS_PASSWORD}'"' < templates/tmp/configmap.yaml.tmp)
echo "$YAML" > templates/tmp/configmap.yaml.tmp

rm -f  templates/tmp/configmap.yaml.tmp

echo "$YAML" > k8s/configmap.yaml

# FILE k8s/ingress.yaml

cp templates/k8s/ingress.yaml.tpl templates/tmp/ingress.yaml.tmp

YAML=$(docker run -i --rm mikefarah/yq eval '.spec.rules[0].host="'${APP_URL_DOMAIN}'"' < templates/tmp/ingress.yaml.tmp)
echo "$YAML" > templates/tmp/ingress.yaml.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.spec.rules[1].host="'${FRONT_URL_DOMAIN}'"' < templates/tmp/ingress.yaml.tmp)
echo "$YAML" > templates/tmp/ingress.yaml.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.spec.rules[2].host="'${ADMIN_URL_DOMAIN}'"' < templates/tmp/ingress.yaml.tmp)
echo "$YAML" > templates/tmp/ingress.yaml.tmp
YAML=$(docker run -i --rm mikefarah/yq eval '.spec.rules[3].host="'${MAILHOG_URL_DOMAIN}'"' < templates/tmp/ingress.yaml.tmp)
echo "$YAML" > templates/tmp/ingress.yaml.tmp
rm -f  templates/tmp/ingress.yaml.tmp

echo "$YAML" > k8s/ingress.yaml

