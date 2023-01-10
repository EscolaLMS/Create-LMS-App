APP_NAME="${APP_NAME:-Wellms}"
APP_ENV="${APP_ENV:-}"
APP_KEY=base64:4eRGpWIIGunZD3AlUrgbeYc29+tC6l2Ky7EMJGO5tqY=
APP_DEBUG="${APP_DEBUG:-false}"
APP_LOG_LEVEL="${APP_LOG_LEVEL:-debug}"
APP_URL="${APP_URL:-http://api.wellms.localhost}"

DB_CONNECTION="${DB_CONNECTION:-pgsql}"
DB_HOST="${DB_HOST:-postgres}"
DB_PORT="${DB_PORT:-5432}"
DB_DATABASE="${DB_DATABASE:-default}"
DB_USERNAME="${DB_USERNAME:-default}"
DB_PASSWORD="${DB_PASSWORD:-secret}"

REDIS_HOST="${REDIS_HOST:-redis}"
REDIS_PASSWORD="${REDIS_PASSWORD:-password}"
REDIS_PORT="${REDIS_PORT:-6379}"

BROADCAST_DRIVER="${BROADCAST_DRIVER:-log}"
CACHE_DRIVER="${CACHE_DRIVER:-redis}"
SESSION_DRIVER="${SESSION_DRIVER:-cookie}"
QUEUE_DRIVER="${QUEUE_DRIVER:-redis}"

QUEUE_CONNECTION="${QUEUE_CONNECTION:-redis}"

MAIL_DRIVER="${MAIL_DRIVER:-smtp}"smtp
MAIL_HOST="${MAIL_HOST:-mailhog}"mailhog
MAIL_PORT="${MAIL_PORT:-1025}"1025
MAIL_USERNAME="${MAIL_USERNAME:-null}"null
MAIL_PASSWORD="${MAIL_PASSWORD:-null}"null
MAIL_ENCRYPTION="${MAIL_ENCRYPTION:-}"

FACEBOOK_CLIENT_ID="${FACEBOOK_CLIENT_ID:-}"
FACEBOOK_CLIENT_SECRET="${FACEBOOK_CLIENT_SECRET:-}"
CALLBACK_URL_FACEBOOK="${CALLBACK_URL_FACEBOOK:-}"

GOOGLE_CLIENT_ID="${GOOGLE_CLIENT_ID:-}"
GOOGLE_CLIENT_SECRET="${GOOGLE_CLIENT_SECRET:-}"
CALLBACK_URL_GOOGLE="${CALLBACK_URL_GOOGLE:-}"

PAYMENTS_STRIPE_SECRET_KEY="${PAYMENTS_STRIPE_SECRET_KEY:-sk_test_51Ig8icJ9tg9t712TG1Odn17fisxXM9y01YrDBxC4vd6FJMUsbB3bQvXYs8Oiz9U2GLH1mxwQ2BCjXcjc3gxEPKTT00tx6wtVco}"
PAYMENTS_STRIPE_PUBLISHABLE_KEY="${PAYMENTS_STRIPE_PUBLISHABLE_KEY:-pk_test_51Ig8icJ9tg9t712TnCR6sKY9OXwWoFGWH4ERZXoxUVIemnZR0B6Ei0MzjjeuWgOzLYKjPNbT8NbG1ku1T2pGCP4B00GnY0uusI}"

MJML_BINARY_PATH="${MJML_BINARY_PATH:-/usr/bin/mjml}"

TRACKER_ENABLED="${TRACKER_ENABLED:-false}"

SENTRY_DSN= "https://1abed5b3f95e41be8e1c39c33af12506@sentry.etd24.pl/96"
SENTRY_TRACES_SAMPLE_RATE= "1"