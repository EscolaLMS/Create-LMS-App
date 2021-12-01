# Create LMS APP

## Installation

Assuming

- you're on MacOS or Linux
- you have `node.js` installed
- you have `docker` & `docker-composer` installed
- ports 1000,8001,8002 are free

You have the following options

### Installation from script

Run `npx --package=@escolalms/cla pull_init`

### Installation from source

Clone this repository then,

in order to launch LMS

run `./init.sh` shell script

## First steps

Once everything is installed (takes a while)

- http://localhost:1000/api/documentation API Swagger documentation
- http://localhost:8001 admin panel credentials username: admin@escola-lms.com password: secret
- http://localhost:8002 demo panel credentials username: student@escola-lms.com password: secret

## Troubleshooting

- please create issue in this repository
- Windows users - this package is not tested on your system.
