(cors) {
  @origin{args.0} header Origin {args.0}
  header @origin{args.0} Access-Control-Allow-Origin "{args.0}"
  header Access-Control-Allow-Credentials true
}

http://$ADMIN_URL_DOMAIN {
	reverse_proxy admin:80
}

http://$FRONT_URL_DOMAIN {
	reverse_proxy app:80
}

http://$APP_URL_DOMAIN  {
	php_fastcgi api:9000 {	
		header_down -Access-Control-Allow-Origin	
	}
	import cors $ADMIN_URL
	import cors $FRONT_URL
}

http://$MAILHOG_URL_DOMAIN  {
	reverse_proxy mailhog:8025
}

http://$REPORTBRO_URL_DOMAIN  {
	reverse_proxy reportbro:8000
}

http://$STORAGE_URL_DOMAIN {
    reverse_proxy minio:9000
}

http://$MINIO_URL_DOMAIN {
    reverse_proxy minio:9001
}
