#!/bin/bash

# generate random secure passwords
DB_PASSWORD=$(openssl rand -hex 12);
REDIS_PASSWORD=$(openssl rand -hex 12);

# generated 
NAMESPACE="${NAMESPACE:-escolalms}"  
APP_URL="${APP_URL:-http://api.wellms.localhost}"  
ADMIN_URL="${ADMIN_URL:-http://admin.wellms.localhost}"  
FRONT_URL="${FRONT_URL:-http://app.wellms.localhost}"  
MAILHOG_URL="${MAILHOG_URL:-http://mailhog.wellms.localhost}"  
REPORTBRO_URL="${REPORTBRO_URL:-http://reportbro.wellms.localhost}"  

# fetch just domain from URLs 
FRONT_URL_DOMAIN="$(echo "$FRONT_URL" | awk -F/ '{print $3}')"
ADMIN_URL_DOMAIN="$(echo "$ADMIN_URL" | awk -F/ '{print $3}')"
APP_URL_DOMAIN="$(echo "$APP_URL" | awk -F/ '{print $3}')"
MAILHOG_URL_DOMAIN="$(echo "$MAILHOG_URL" | awk -F/ '{print $3}')"
REPORTBRO_URL_DOMAIN="$(echo "$REPORTBRO_URL" | awk -F/ '{print $3}')"

cp templates/k8s/namespace.yaml.tpl k8s/namespace.yaml
cp templates/k8s/configmap.yaml.tpl k8s/configmap.yaml
cp templates/k8s/deploy-admin.yaml.tpl k8s/deploy-admin.yaml
cp templates/k8s/deploy-backend.yaml.tpl k8s/deploy-backend.yaml
cp templates/k8s/deploy-frontend.yaml.tpl k8s/deploy-frontend.yaml
cp templates/k8s/deploy-mailhog.yaml.tpl k8s/deploy-mailhog.yaml
cp templates/k8s/deploy-reportbro.yaml.tpl k8s/deploy-reportbro.yaml
cp templates/k8s/deploy-postgres.yaml.tpl k8s/deploy-postgres.yaml
cp templates/k8s/deploy-redis.yaml.tpl k8s/deploy-redis.yaml
cp templates/k8s/deploy-scheduler-queue.yaml.tpl k8s/deploy-scheduler-queue.yaml
cp templates/k8s/ingress.yaml.tpl k8s/ingress.yaml
cp templates/k8s/volume-backend.yaml.tpl k8s/volume-backend.yaml

echo -e "$(docker run -i --rm mikefarah/yq eval '.data.POSTGRES_PASSWORD="'${DB_PASSWORD}'" | .data.API_URL="'${APP_URL}'" | .data.LARAVEL_APP_URL="'${APP_URL}'" | .data.LARAVEL_DB_PASSWORD="'${DB_PASSWORD}'" | .data.LARAVEL_REDIS_PASSWORD="'${REDIS_PASSWORD}'" ' < k8s/configmap.yaml)" > k8s/configmap.yaml
echo -e "$(docker run -i --rm mikefarah/yq eval '.spec.rules[0].host="'${APP_URL_DOMAIN}'" | .spec.rules[1].host="'${FRONT_URL_DOMAIN}'" | .spec.rules[2].host="'${ADMIN_URL_DOMAIN}'" | .spec.rules[3].host="'${MAILHOG_URL_DOMAIN}'" | .spec.rules[4].host="'${REPORTBRO_URL_DOMAIN}'"' < k8s/ingress.yaml)" > k8s/ingress.yaml

# Namespaces
echo -e "$(docker run -i --rm mikefarah/yq eval '.metadata.namespace="'${NAMESPACE}'" | .metadata.name="'${NAMESPACE}'"' < k8s/namespace.yaml)" > k8s/namespace.yaml
echo -e "$(docker run -i --rm mikefarah/yq eval '.metadata.namespace="'${NAMESPACE}'"' < k8s/configmap.yaml)" > k8s/configmap.yaml
echo -e "$(docker run -i --rm mikefarah/yq eval '.metadata.namespace="'${NAMESPACE}'"' < k8s/deploy-admin.yaml)" > k8s/deploy-admin.yaml
echo -e "$(docker run -i --rm mikefarah/yq eval '.metadata.namespace="'${NAMESPACE}'"' < k8s/deploy-backend.yaml)" > k8s/deploy-backend.yaml
echo -e "$(docker run -i --rm mikefarah/yq eval '.metadata.namespace="'${NAMESPACE}'"' < k8s/deploy-frontend.yaml)" > k8s/deploy-frontend.yaml
echo -e "$(docker run -i --rm mikefarah/yq eval '.metadata.namespace="'${NAMESPACE}'"' < k8s/deploy-mailhog.yaml)" > k8s/deploy-mailhog.yaml
echo -e "$(docker run -i --rm mikefarah/yq eval '.metadata.namespace="'${NAMESPACE}'"' < k8s/deploy-reportbro.yaml)" > k8s/deploy-reportbro.yaml
echo -e "$(docker run -i --rm mikefarah/yq eval '.metadata.namespace="'${NAMESPACE}'"' < k8s/deploy-postgres.yaml)" > k8s/deploy-postgres.yaml
echo -e "$(docker run -i --rm mikefarah/yq eval '.metadata.namespace="'${NAMESPACE}'"' < k8s/deploy-redis.yaml)" > k8s/deploy-redis.yaml
echo -e "$(docker run -i --rm mikefarah/yq eval '.metadata.namespace="'${NAMESPACE}'"' < k8s/deploy-scheduler-queue.yaml)" > k8s/deploy-scheduler-queue.yaml
echo -e "$(docker run -i --rm mikefarah/yq eval '.metadata.namespace="'${NAMESPACE}'"' < k8s/ingress.yaml)" > k8s/ingress.yaml
echo -e "$(docker run -i --rm mikefarah/yq eval '.metadata.namespace="'${NAMESPACE}'"' < k8s/volume-backend.yaml)" > k8s/volume-backend.yaml



