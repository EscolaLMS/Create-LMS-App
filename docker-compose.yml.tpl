version: "3.7"

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

  # NOTE binding emptyfile.conf disable supervisor service

  api:
    image: escolalms/api:latest
    networks:
      - escola_lms
    depends_on:
      - postgres

    volumes:
      #      - ./emptyfile.conf:/etc/supervisor/custom.d/horizon.conf
      #      - ./emptyfile.conf:/etc/supervisor/custom.d/scheduler.conf
      #      - ./emptyfile.conf:/etc/supervisor/custom.d/nginx.conf
      - ./storage:/var/www/html/storage
      - ./.env:/var/www/html/.env
      - ./vendor/escolalms/headless-h5p:/var/www/html/vendor/escolalms/headless-h5p
      - ./vendor/h5p-php-library:/var/www/html/vendor/h5p/h5p-core
      - ./vendor/h5p-editor-php-library:/var/www/html/vendor/h5p/h5p-editor

  #   horizon:
  #     image: escolalms/api:latest
  #     networks:
  #       - escola_lms
  #    depends_on: 
  #      postgres:
  #        condition: service_healthy
  #     volumes:
  # #     - ./emptyfile.conf:/etc/supervisor/custom.d/horizon.conf
  #       - ./emptyfile.conf:/etc/supervisor/custom.d/scheduler.conf
  #       - ./emptyfile.conf:/etc/supervisor/custom.d/nginx.conf
  #       - ./storage:/var/www/html/storage
  #       - ./.env:/var/www/html/.env

  #   scheduler:
  #     image: escolalms/api:latest
  #     networks:
  #       - escola_lms
  #    depends_on: 
  #      postgres:
  #        condition: service_healthy
  #     volumes:
  #       - ./emptyfile.conf:/etc/supervisor/custom.d/horizon.conf
  # #      - ./emptyfile.conf:/etc/supervisor/custom.d/scheduler.conf
  #       - ./emptyfile.conf:/etc/supervisor/custom.d/nginx.conf
  #       - ./storage:/var/www/html/storage
  #       - ./.env:/var/www/html/.env      

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

#    ports:
#      - 1025:1025 # smtp server
#      - 8025:8025 # web ui
