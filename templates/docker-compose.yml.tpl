version: "3.9"
networks:
  escola_lms:
    name: escola_lms
    driver: bridge
services:
  proxy:
    user: $DOCKER_USER
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
      - YBUG_ID=01m1nn5zqystt1qq5n11
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
    user: $DOCKER_USER
    image: escolalms/api:latest
    networks:
      - escola_lms
    depends_on:
      postgres:
        condition: service_healthy
    volumes:
      # this should be removed after h5p is CDN ready
      - ./storage:/var/www/html/storage
      - ./.env:/var/www/html/.env
    environment:
      - DISBALE_PHP_FPM=false
      - DISBALE_NGINX=false
      - DISBALE_HORIZON=false
      - DISBALE_SCHEDULER=false
      - LARAVEL_SENTRY_DSN=${SENTRY_DSN}
      - LARAVEL_SENTRY_TRACES_SAMPLE_RATE=0.1
  postgres:
    image: postgres:12
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
      - ./docker/minio_storage:/data
      - ./docker/conf/minio:/docker-entrypoint-initdb.d
    environment:
      MINIO_DEFAULT_BUCKETS: "${AWS_BUCKET}:download"
      MINIO_ROOT_USER: ${AWS_ACCESS_KEY_ID}
      MINIO_ROOT_PASSWORD: ${AWS_SECRET_ACCESS_KEY}
      AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}
      AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY}
      AWS_BUCKET: ${AWS_BUCKET}
      AWS_ENDPOINT: ${AWS_ENDPOINT}
