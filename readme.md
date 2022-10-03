# Create LMS APP

This package contains all the resources need to install Wellms Headless LMS from docker-images

## Installation on MacOs or Linux

Below are instruction on how to install Wellms on MacOs or Linux.
Windows with WSL should work fine, yet there might be some issues

- please [do share them](https://github.com/EscolaLMS/Create-LMS-App/issues/new) with us.

## Environment

## Kubernetes

### Without `helm`

All `yaml` file templates are inside [`k8s/tpls`](k8s/tpls) folder

You can either generate yaml by calling bash script `cd k8s && bash generate.sh`
or by calling makefile job `make
or but setting all config manually

Once `yaml` files are in `k8s` folder run `kubectl apply -f k8s`

#### Custom domain

Those are env variables you can set while running generate

```bash
APP_URL="${APP_URL:-http://api.wellms.localhost}"
ADMIN_URL="${ADMIN_URL:-http://admin.wellms.localhost}"
FRONT_URL="${FRONT_URL:-http://app.wellms.localhost}"
MAILHOG_URL="${MAILHOG_URL:-http://mailhog.wellms.localhost}"
```

#### Makefile jobs

### With `helm`

`WIP`

## From docker container images

Below are instructions how to install Wellms from [https://hub.docker.com/search?q=escolalms](docker images) in various ways.

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

The `source` means source code of this repository, not the actual Wellms components. Tasks describes below will install docker containers.

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
api:
  image: escolalms/api:latest
  networks:
    - escola_lms
  volumes:
    - ./storage:/var/www/html/storage
    - ./.env:/var/www/html/.env
  environment:
    - DISBALE_PHP_FPM=false
    - DISBALE_NGINX=false
    - DISBALE_HORIZON=true
    - DISBALE_SCHEDULER=true

horizon:
  image: escolalms/api:latest
  networks:
    - escola_lms
  volumes:
    - ./storage:/var/www/html/storage
    - ./.env:/var/www/html/.env
  environment:
    - DISBALE_PHP_FPM=true
    - DISBALE_NGINX=true
    - DISBALE_HORIZON=false
    - DISBALE_SCHEDULER=true

scheduler:
  image: escolalms/api:latest
  networks:
    - escola_lms
  volumes:
    - ./storage:/var/www/html/storage
    - ./.env:/var/www/html/.env
  environment:
    - DISBALE_PHP_FPM=true
    - DISBALE_NGINX=true
    - DISBALE_HORIZON=true
    - DISBALE_SCHEDULER=false
```
