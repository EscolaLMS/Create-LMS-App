
$ADMIN_URL {
	reverse_proxy admin:80
}

$APP_URL {
	reverse_proxy app:80
}

$API_URL  {
	reverse_proxy api:80
}

$MAILHOG_URL  {
	reverse_proxy mailhog:8025
}

