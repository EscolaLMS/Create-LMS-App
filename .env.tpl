APP_NAME=Wellms
APP_ENV=production
APP_KEY=base64:4eRGpWIIGunZD3AlUrgbeYc29+tC6l2Ky7EMJGO5tqY=
APP_DEBUG=false
APP_LOG_LEVEL=debug
APP_URL=$API_URL

DB_CONNECTION=pgsql
DB_HOST=postgres
DB_PORT=5432
DB_DATABASE=default
DB_USERNAME=default
DB_PASSWORD=$DBPASS_RND

REDIS_HOST=redis
REDIS_PASSWORD=$REDISPASS_RND
REDIS_PORT=6379


BROADCAST_DRIVER=log
CACHE_DRIVER=redis
SESSION_DRIVER=cookie
QUEUE_DRIVER=redis

QUEUE_CONNECTION=redis

MAIL_DRIVER=smtp
MAIL_HOST=mailhog
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=

FACEBOOK_CLIENT_ID=
FACEBOOK_CLIENT_SECRET=
CALLBACK_URL_FACEBOOK=

GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
CALLBACK_URL_GOOGLE=

PAYMENTS_STRIPE_SECRET_KEY='sk_test_51Ig8icJ9tg9t712TG1Odn17fisxXM9y01YrDBxC4vd6FJMUsbB3bQvXYs8Oiz9U2GLH1mxwQ2BCjXcjc3gxEPKTT00tx6wtVco'
PAYMENTS_STRIPE_PUBLISHABLE_KEY='pk_test_51Ig8icJ9tg9t712TnCR6sKY9OXwWoFGWH4ERZXoxUVIemnZR0B6Ei0MzjjeuWgOzLYKjPNbT8NbG1ku1T2pGCP4B00GnY0uusI'

MJML_BINARY_PATH=/usr/bin/mjml

TRACKER_ENABLED=false
