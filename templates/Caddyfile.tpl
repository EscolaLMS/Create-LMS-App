(cors) {
  @origin{args.0} header Origin {args.0}
  header @origin{args.0} Access-Control-Allow-Origin "{args.0}"
  header Access-Control-Allow-Credentials true
}

$ADMIN_URL_DOMAIN {
	reverse_proxy admin:80
}

$FRONT_URL_DOMAIN {
	reverse_proxy app:80
}

$APP_URL_DOMAIN  {
	php_fastcgi api:9000 {	
		header_down -Access-Control-Allow-Origin	
	}
	import cors $ADMIN_URL
	import cors $FRONT_URL
}

$MAILHOG_URL_DOMAIN  {
	reverse_proxy mailhog:8025
}

$REPORTBRO_URL_DOMAIN  {
	reverse_proxy reportbro:8000
}