version: "3.9"
networks:
  escola_lms:
    name: escola_lms
    driver: bridge
services:
  proxy:
    image: caddy
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile
      - ./caddy/certs:/etc/caddy/certs
      - ./caddy/data:/data
      - ./caddy/config:/config
    networks:
      - escola_lms
    ports:
      - "80:80"
      - "443:443"
  app:
    image: escolalms/demo:latest
    platform: linux/amd64
    environment:
      - API_URL=${APP_URL}
      - SENTRYDSN=${SENTRY_DSN}
      - YBUG_ID=${YBUG_ID}
    networks:
      - escola_lms
  admin:
    image: escolalms/admin:latest
    platform: linux/amd64
    environment:
      - API_URL=${APP_URL}
      - REACT_APP_YBUG=${YBUG_ID}
      - REACT_APP_SENTRYDSN=${SENTRY_DSN}
    networks:
      - escola_lms
  api:
    image: escolalms/api:latest
    networks:
      - escola_lms
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy

    environment:
      - DISABLE_PHP_FPM=false
      - DISABLE_NGINX=false
      - DISABLE_HORIZON=false
      - DISABLE_SCHEDULER=false
      - LARAVEL_SENTRY_DSN=${SENTRY_DSN}
      - LARAVEL_INITIAL_USER_EMAIL=superadmin@escolalms.com
      - LARAVEL_INITIAL_USER_PASSWORD=secret
      - LARAVEL_SENTRY_TRACES_SAMPLE_RATE=0.1
      - LARAVEL_APP_NAME="${APP_NAME:-Wellms}"
      - LARAVEL_APP_ENV="${APP_ENV:-production}"
      - LARAVEL_APP_KEY="${APP_KEY:-base64:4eRGpWIIGunZD3AlUrgbeYc29+tC6l2Ky7EMJGO5tqY=}"
      - LARAVEL_APP_DEBUG="${APP_DEBUG:-false}"
      - LARAVEL_APP_LOG_LEVEL="${APP_LOG_LEVEL:-debug}"
      - LARAVEL_APP_URL="${APP_URL:-http://api.wellms.localhost}"
      - LARAVEL_DB_CONNECTION="${DB_CONNECTION:-pgsql}"
      - LARAVEL_DB_HOST="${DB_HOST:-postgres}"
      - LARAVEL_DB_PORT="${DB_PORT:-5432}"
      - LARAVEL_DB_DATABASE="${DB_DATABASE:-default}"
      - LARAVEL_DB_USERNAME="${DB_USERNAME:-default}"
      - LARAVEL_DB_PASSWORD="${DB_PASSWORD:-secret}"
      - LARAVEL_REDIS_HOST="${REDIS_HOST:-redis}"
      - LARAVEL_REDIS_PASSWORD="${REDIS_PASSWORD:-password}"
      - LARAVEL_REDIS_PORT="${REDIS_PORT:-6379}"
      - LARAVEL_BROADCAST_DRIVER="${BROADCAST_DRIVER:-log}"
      - LARAVEL_CACHE_DRIVER="${CACHE_DRIVER:-redis}"
      - LARAVEL_SESSION_DRIVER="${SESSION_DRIVER:-cookie}"
      - LARAVEL_QUEUE_DRIVER="${QUEUE_DRIVER:-redis}"
      - LARAVEL_QUEUE_CONNECTION="${QUEUE_CONNECTION:-redis}"
      - LARAVEL_MAIL_DRIVER="${MAIL_DRIVER:-smtp}"
      - LARAVEL_MAIL_HOST="${MAIL_HOST:-mailhog}"
      - LARAVEL_MAIL_PORT="${MAIL_PORT:-1025}"
      - LARAVEL_MAIL_USERNAME="${MAIL_USERNAME:-null}"
      - LARAVEL_MAIL_PASSWORD="${MAIL_PASSWORD:-null}"
      - LARAVEL_MAIL_ENCRYPTION="${MAIL_ENCRYPTION:-}"
      - LARAVEL_FACEBOOK_CLIENT_ID="${FACEBOOK_CLIENT_ID:-}"
      - LARAVEL_FACEBOOK_CLIENT_SECRET="${FACEBOOK_CLIENT_SECRET:-}"
      - LARAVEL_CALLBACK_URL_FACEBOOK="${CALLBACK_URL_FACEBOOK:-}"
      - LARAVEL_GOOGLE_CLIENT_ID="${GOOGLE_CLIENT_ID:-}"
      - LARAVEL_GOOGLE_CLIENT_SECRET="${GOOGLE_CLIENT_SECRET:-}"
      - LARAVEL_CALLBACK_URL_GOOGLE="${CALLBACK_URL_GOOGLE:-}"
      - LARAVEL_PAYMENTS_STRIPE_SECRET_KEY="${PAYMENTS_STRIPE_SECRET_KEY:-sk_test_51Ig8icJ9tg9t712TG1Odn17fisxXM9y01YrDBxC4vd6FJMUsbB3bQvXYs8Oiz9U2GLH1mxwQ2BCjXcjc3gxEPKTT00tx6wtVco}"
      - LARAVEL_PAYMENTS_STRIPE_PUBLISHABLE_KEY="${PAYMENTS_STRIPE_PUBLISHABLE_KEY:-pk_test_51Ig8icJ9tg9t712TnCR6sKY9OXwWoFGWH4ERZXoxUVIemnZR0B6Ei0MzjjeuWgOzLYKjPNbT8NbG1ku1T2pGCP4B00GnY0uusI}"
      - LARAVEL_MJML_BINARY_PATH="${MJML_BINARY_PATH:-/usr/bin/mjml}"
      - LARAVEL_TRACKER_ENABLED="${TRACKER_ENABLED:-false}"
      - LARAVEL_SENTRY_DSN="${SENTRY_DSN:-http://1abed5b3f95e41be8e1c39c33af12506@relay:3000/96}"
      - LARAVEL_SENTRY_TRACES_SAMPLE_RATE="${SENTRY_TRACES_SAMPLE_RATE:-0.5}"
      - LARAVEL_SENTRY_PROFILES_SAMPLE_RATE="${SENTRY_PROFILES_SAMPLE_RATE:-0.5}"
      - LARAVEL_FILESYSTEM_DRIVER=s3
      - LARAVEL_AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-masoud}"
      - LARAVEL_AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-tg9t712TG1Odn17fisxXM9y01YrD}"
      - LARAVEL_AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}"
      - LARAVEL_AWS_BUCKET="${AWS_BUCKET:-wellms}"
      - LARAVEL_AWS_ENDPOINT="${AWS_ENDPOINT:-http://minio:9000}"
      - LARAVEL_AWS_URL="${AWS_URL:-http://storage.wellms.localhost/wellms}"
      - LARAVEL_AWS_USE_PATH_STYLE_ENDPOINT="${AWS_USE_PATH_STYLE_ENDPOINT:-true}"
      - LARAVEL_YBUG_ID="${YBUG_ID:-01m1nn5zqystt1qq5n11}"
  postgres:
    image: postgres:17 
    networks:
      - escola_lms
    healthcheck:
      test: ["CMD-SHELL", "pg_isready"]
      interval: 30s
      timeout: 60s
      retries: 5
      start_period: 80s
    volumes:
      - ./docker/postgres-data:/var/lib/postgresql/data
      - ./docker/postgres-backups:/var/lib/postgresql/backups
    environment:
      - POSTGRES_DB=${DB_DATABASE}
      - POSTGRES_USER=${DB_USERNAME}
      - POSTGRES_PASSWORD=${DB_PASSWORD}
      - TZ=Europe/Warsaw
    ports:
      - "5432:5432"
  redis:
    networks:
      - escola_lms
    image: "redis"
    command: "redis-server --requirepass ${REDIS_PASSWORD}"
    healthcheck:
      interval: 1s
      timeout: 3s
      retries: 5
      test:
        ["CMD", "redis-cli", "-a", "${REDIS_PASSWORD}", "--raw", "incr", "ping"]
  adminer:
    networks:
      - escola_lms
    image: adminer
    ports:
      - 8078:8080
  mailhog:
    networks:
      - escola_lms
    image: mailhog/mailhog
    platform: linux/amd64
    logging:
      driver: "none" # disable saving logs
  reportbro:
    networks:
      - escola_lms
    image: escolalms/reportbro-server:latest
  relay:
    image: getsentry/relay
    volumes:
      - ./config/relay/:/work/.relay/
    networks:
      - escola_lms
  minio:
    image: bitnami/minio
    networks:
      - escola_lms
      #    ports:
      #      - "9000:9000"
      #      - "9001:9001"
    volumes:
      - ./docker/minio_storage:/bitnami/minio/data
      - ./docker/conf/minio:/docker-entrypoint-initdb.d
    environment:
      MINIO_DEFAULT_BUCKETS: "${AWS_BUCKET}:download"
      MINIO_ROOT_USER: ${AWS_ACCESS_KEY_ID}
      MINIO_ROOT_PASSWORD: ${AWS_SECRET_ACCESS_KEY}
      AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}
      AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY}
      AWS_BUCKET: ${AWS_BUCKET}
      AWS_ENDPOINT: ${AWS_ENDPOINT}
