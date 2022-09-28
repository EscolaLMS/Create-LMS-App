# Create LMS APP

Development version

## Kubernetes

Use provided `yml` k8s files to deploy instance.

1. Edit [`k8s/ingress.yaml`](k8s/ingress.yaml) setup you domain names
2. Apply all yaml's `kubectl apply -f k8s`

## Installation on MacOs or Linux

### Requirements

- you have `docker` & `docker-composer` installed
- port 80 is free

### Installation from script

Run `npx --package=@escolalms/cla lms`

### Installation from source

Clone this repository then,

in order to launch LMS

run `make init` shell script

## Instalation on Windows

### Requirements

- `WSL` installed (https://docs.microsoft.com/en-us/windows/wsl/install)
- `Docker` installed (https://docs.docker.com/desktop/windows/install/) and configured to use WSL
- `make` available in PowerShell (for example, you can install `Chocolatey` https://chocolatey.org/install and then install `make` using it)

_Recommended_: use Windows Terminal (https://apps.microsoft.com/store/detail/windows-terminal/) and latest PowerShell (https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2)

### Installation from source

- Clone this repository
- Run `make init` in PowerShell (and not in WSL shell, because it will lead to problems with binding Postgres data volume for persistence)

## First steps

Once everything is installed (takes a while)

- http://api.wellms.localhost/api/documentation API Swagger documentation
- http://admin.wellms.localhost admin panel credentials username: admin@escola-lms.com password: secret
- http://app.wellms.localhost demo panel credentials username: student@escola-lms.com password: secret
- http://mailhog.wellms.localhost demo panel credentials username: student@escola-lms.com password: secret

## Troubleshooting

- please create issue in this repository
- Windows users - this package is not tested on your system.

## Custom domains

- Amends [Caddyfile](Caddyfile) referring to the [official documentation](https://caddyserver.com/docs/caddyfile)

## Scaling php-fpm, Horizon & Scheduler.

By default all 3 threads phpfpm, Laravels Horizon and Scheduler are severed by one [image container](https://github.com/EscolaLMS/API/blob/develop/Dockerfile)

- `php-fpm` serve main Laravel REST API (with [nginx](https://github.com/EscolaLMS/API/tree/develop/docker/conf/nginx) and [caddy](https://github.com/EscolaLMS/Create-LMS-App/blob/main/Caddyfile))
- [`horizon`](https://laravel.com/docs/9.x/horizon) is responsible for all [queue services](https://laravel.com/docs/9.x/queues)
- [`Task Scheduling`](https://laravel.com/docs/9.x/scheduling) is responsible for all cron jobs

All of above including nginx are served by `supervisor`, definition files are [listed here](https://github.com/EscolaLMS/API/tree/develop/docker/conf/supervisor)

You can scale this by setting each process into separate image container, just by amending `docker-compose.yml` in the following way

```yml
# NOTE binding emptyfile.conf disable supervisor service

api:
  image: escolalms/api:latest
  networks:
    - escola_lms
  volumes:
    - ./emptyfile.conf:/etc/supervisor/custom.d/horizon.conf
    - ./emptyfile.conf:/etc/supervisor/custom.d/scheduler.conf
    #      - ./emptyfile.conf:/etc/supervisor/custom.d/nginx.conf
    - ./storage:/var/www/html/storage
    - ./.env:/var/www/html/.env

horizon:
  image: escolalms/api:latest
  networks:
    - escola_lms
  volumes:
    #     - ./emptyfile.conf:/etc/supervisor/custom.d/horizon.conf
    - ./emptyfile.conf:/etc/supervisor/custom.d/scheduler.conf
    - ./emptyfile.conf:/etc/supervisor/custom.d/nginx.conf
    - ./storage:/var/www/html/storage
    - ./.env:/var/www/html/.env

scheduler:
  image: escolalms/api:latest
  networks:
    - escola_lms
  volumes:
    - ./emptyfile.conf:/etc/supervisor/custom.d/horizon.conf
    #      - ./emptyfile.conf:/etc/supervisor/custom.d/scheduler.conf
    - ./emptyfile.conf:/etc/supervisor/custom.d/nginx.conf
    - ./storage:/var/www/html/storage
    - ./.env:/var/www/html/.env
```
