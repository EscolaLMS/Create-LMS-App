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
	reverse_proxy api:9000 {
        header_up -Access-Control-Allow-Origin
        header_down -Access-Control-Allow-Origin
        transport fastcgi {
            env SCRIPT_FILENAME /var/www/html/index.php
        }        
    }
	import cors $ADMIN_URL
	import cors $FRONT_URL
}

$STORAGE_URL_DOMAIN {
    reverse_proxy minio:9000
}

$MINIO_URL_DOMAIN {
    reverse_proxy minio:9001
}