version: "3.7"

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
    environment:
      - API_URL=http://api.wellms.localhost
    networks:
      - escola_lms

  admin:
    image: escolalms/admin:latest
    environment:
      - API_URL=http://api.wellms.localhost
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
      - ./nginx.conf:/etc/nginx/conf.d/php.conf
      - ./supervisord.conf:/etc/supervisor/supervisord.conf
    environment:
    - DISBALE_PHP_FPM=false
    - DISBALE_NGINX=false
    - DISBALE_HORIZON=false
    - DISBALE_SCHEDULER=false

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
    logging:
      driver: "none" # disable saving logs

  reportbro:
    networks:
      - escola_lms
    image: escolalms/reportbro-server:latest

