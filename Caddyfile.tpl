$ADMIN_URL_DOMAIN {
	reverse_proxy admin:80
}

$APP_URL_DOMAIN {
	reverse_proxy app:80
}

$API_URL_DOMAIN  {
	reverse_proxy api:80
}

$MAILHOG_URL_DOMAIN  {
	reverse_proxy mailhog:8025
}

