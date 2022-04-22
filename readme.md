# Create LMS APP

Development version

## Installation

Assuming

- you're on MacOS or Linux
- you have `docker` & `docker-composer` installed
- ports 80,1000,3000 are free

You have the following options

### Installation from script

Run `npx --package=@escolalms/cla lms`

### Installation from source

Clone this repository then,

in order to launch LMS

run `make init` shell script

## First steps

Once everything is installed (takes a while)

- http://localhost:1000/api/documentation API Swagger documentation
- http://localhost:3000 admin panel credentials username: admin@escola-lms.com password: secret
- http://localhost demo panel credentials username: student@escola-lms.com password: secret

## Troubleshooting

- please create issue in this repository
- Windows users - this package is not tested on your system.
