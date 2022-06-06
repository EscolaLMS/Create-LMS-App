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

## Troubleshooting

- please create issue in this repository
- Windows users - this package is not tested on your system.

## Custom domains

- Amends [Caddyfile](Caddyfile) referring to the [official documentation](https://caddyserver.com/docs/caddyfile)
