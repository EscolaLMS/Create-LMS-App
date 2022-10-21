
apiVersion: v1
kind: ConfigMap
metadata:
  name: laravel-config
  labels:
    name: laravel-config
  namespace: escolalms
data:

  # PostgreSQL credentials
  POSTGRES_DB: default
  POSTGRES_USER: default
  POSTGRES_PASSWORD: P7qlhud4rSEpQFup
  TZ: Europe/Warsaw

  API_URL: "http://backend.localhost"

  # Laravel .env 
  # all env with LARAVEL_ prefix will be replaced in .env, see https://github.com/EscolaLMS/API/blob/develop/docker/envs/envs.php
  LARAVEL_APP_ENV: "production"
  LARAVEL_APP_KEY: "base64:vw6G2uP8LV22haEERtzr5yDCBraLrMwbxlbSJDA97uk="
  LARAVEL_APP_DEBUG: "false"
  LARAVEL_APP_LOG: "errorlog"
  LARAVEL_APP_LOG_LEVEL: "debug"
  LARAVEL_APP_URL: "backend.localhost"

  LARAVEL_DB_CONNECTION: pgsql
  LARAVEL_DB_HOST: escolalms-postgres
  LARAVEL_DB_PORT: "5432"
  LARAVEL_DB_DATABASE: default
  LARAVEL_DB_USERNAME: default
  LARAVEL_DB_PASSWORD: P7qlhud4rSEpQFup

  LARAVEL_BROADCAST_DRIVER: "log"
  LARAVEL_CACHE_DRIVER: "redis"
  LARAVEL_SESSION_DRIVER: "file"
  LARAVEL_QUEUE_DRIVER: "redis"

  LARAVEL_REDIS_HOST: escolalms-redis
  LARAVEL_REDIS_PASSWORD: P7qlhud4rSEpQFup
  LARAVEL_REDIS_PORT: "6379"

  LARAVEL_MAIL_DRIVER: "smtp"
  LARAVEL_MAIL_HOST: escolalms-mailhog
  LARAVEL_MAIL_PORT: "1025"
  LARAVEL_MAIL_USERNAME: "null"
  LARAVEL_MAIL_PASSWORD: "null"
  LARAVEL_MAIL_ENCRYPTION: ""

