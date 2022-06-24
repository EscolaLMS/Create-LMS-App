# Create LMS APP

Development version

## Installation

Assuming

- you're on MacOS or Linux
- you have `docker` & `docker-composer` installed
- port 80 is free

You have the following options

### Installation from script

Run `npx --package=@escolalms/cla lms`

### Installation from source

Clone this repository then,

in order to launch LMS

run `make init` shell script

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

- `phpfpm` serve main Laravel REST API (with [nginx](https://github.com/EscolaLMS/API/tree/develop/docker/conf/nginx) and [caddy](https://github.com/EscolaLMS/Create-LMS-App/blob/main/Caddyfile))
- [`horizon`](https://laravel.com/docs/9.x/horizon) is responsible for all [queue services](https://laravel.com/docs/9.x/queues)
- [`Task Scheduling`](https://laravel.com/docs/9.x/scheduling) is responsible for all cron jobs

All of above including nginx are served by `supervisor`, definition files are [listed here](https://github.com/EscolaLMS/API/tree/develop/docker/conf/supervisor)
