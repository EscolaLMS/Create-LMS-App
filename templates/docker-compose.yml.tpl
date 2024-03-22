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
      - API_URL=http://api.wellms.localhost
      - SENTRYDSN=http://1abed5b3f95e41be8e1c39c33af12506@relay:3000/96
      - YBUG_ID=01m1nn5zqystt1qq5n11
    networks:
      - escola_lms
  admin:
    image: escolalms/admin:latest
    platform: linux/amd64
    environment:
      - API_URL=http://api.wellms.localhost
      - REACT_APP_YBUG=01m1nn5zqystt1qq5n11
      - REACT_APP_SENTRYDSN=http://1abed5b3f95e41be8e1c39c33af12506@relay:3000/96
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
      - ./storage:/var/www/html/storage
      - ./.env:/var/www/html/.env
    environment:
    - DISBALE_PHP_FPM=false
    - DISBALE_NGINX=false
    - DISBALE_HORIZON=false
    - DISBALE_SCHEDULER=false
    - LARAVEL_SENTRY_DSN=http://1abed5b3f95e41be8e1c39c33af12506@relay:3000/96
    - LARAVEL_SENTRY_TRACES_SAMPLE_RATE=0.1
  postgres:
    image: postgres:12
    networks:
      - escola_lms
    healthcheck:
      test: [ "CMD-SHELL", "pg_isready" ]
      interval: 30s
      timeout: 60s
      retries: 5
      start_period: 80s
    volumes:
      - ./docker/postgres-data:/var/lib/postgresql/data
      - ./docker/postgres-backups:/var/lib/postgresql/backups
    environment:
      - POSTGRES_DB=default
      - POSTGRES_USER=default
      - POSTGRES_PASSWORD=secret
      - TZ=Europe/Warsaw

    ports:
      - "5432:5432"

  redis:
    networks:
      - escola_lms
    image: "redis"
    command: redis-server --requirepass escola_lms

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


