-include .env
export POSTGRES_DB=postgresql://$(DB_USERNAME):$(DB_PASSWORD)@127.0.0.1:$(DB_PORT)/$(DB_DATABASE)
export NOW_DB_PREFIX=$(shell date +\%Y-\%m-\%d-\%H:\%M:\%S)
export DOCKER_USER=$(id -u)

bash:
	- docker-compose exec -u 1000 api bash

generate-credentials:	
	- bash credentials.sh

dumpautoload: 
	- docker-compose exec -T -u 1000 api bash -c "composer dumpautoload"

generate-new-keys-no-db:
	- docker-compose exec -T -u 1000 api bash -c "php artisan key:generate --force --no-interaction"
	- docker-compose exec -T -u 1000 api bash -c "php artisan passport:keys --force --no-interaction"

generate-new-keys-db:
	- docker-compose exec -T -u 1000 api bash -c "php artisan passport:client --personal --no-interaction"

migrate: 
	- docker-compose exec -T -u 1000 api bash -c "php artisan migrate --force --no-interaction"

permissions-seeder: 
	- docker-compose exec -T -u 1000 api bash -c "php artisan db:seed --class=PermissionsSeeder --force --no-interaction"

content-seeder: 
	- docker-compose exec -T -u 1000 api bash -c "php artisan db:seed --force --no-interaction"

content-rich-seeder: 
	- docker-compose exec -T -u 1000 api bash -c "php artisan db:seed --class=FullDatabaseSeeder --force --no-interaction"

docker-up:
	- docker-compose up -d --remove-orphans	

docker-up-force:
	- docker-compose up -d	--force-recreate

docker-down:	
	- docker-compose stop

docker-pull:	
	- docker-compose pull

docker-update: docker-pull docker-up-force dumpautoload storage-links

restart: 
	- docker-compose stop && docker-compose up -d	

h5p-seed:
	- docker-compose exec -T -u 1000 api bash -c "php artisan db:seed --class=H5PLibrarySeeder --force --no-interaction"
	- docker-compose exec -T -u 1000 api bash -c "php artisan db:seed --class=H5PContentSeeder --force --no-interaction"
	- docker-compose exec -T -u 1000 api bash -c "php artisan db:seed --class=H5PContentCoursesSeeder --force --no-interaction"

storage-links:
	- docker-compose exec -T -u 1000 api bash -c "php artisan storage:link --force --no-interaction"
	- docker-compose exec -T -u 1000 api bash -c "php artisan h5p:storage-link"
	
# creates a backup file into `data` folder
backup-postgres:
	- docker-compose --env-file .env  exec --user=1000 -T postgres bash -c "pg_dump --clean --dbname=$(POSTGRES_DB) -f /var/lib/postgresql/backups/backup-$(NOW_DB_PREFIX).sql"	
	- docker-compose --env-file .env  exec --user=1000 -T postgres bash -c "cp /var/lib/postgresql/backups/backup-$(NOW_DB_PREFIX).sql  /var/lib/postgresql/backups/backup-latest.sql"

# imports database backup from data folder 
# make import BACKUP_FILE=backup-2020-09-15-14:49:22.sql 
# or 
# make import BACKUP_FILE=backup-latest.sql
#import-postgres: backup-postgres

import-postgres: 
	- docker-compose --env-file .env  exec --user=1000 postgres bash -c "psql --dbname=$(POSTGRES_DB) < /var/lib/postgresql/backups/$(BACKUP_FILE)"

flush-postgres: 
	- rm -rf docker/postgres-data	
	- docker-compose down


success: 
	- @echo "Wellms is installed succesfully"
	- @echo "Admin panel http://admin.wellms.localhost"
	- @echo "Demo http://app.wellms.localhost"
	- @echo "API REST http://api.wellms.localhost/api/documentation"
	- @echo "Credentials for admin are username: admin@escolalms.com password: secret"
	- @echo "Credentials for student are username: student@escolalms.com password: secret"
	- @echo "Emails are not sent. See http://mailhog.wellms.localhost mailhog for details"
	- @echo "All productions changes must be set in .env file"
	- @echo "Run 'make bash' to lanuch bash mode, where you can use all 'artisan' commands"	
	- @echo "if you need to attach your domain just change CaddyFiles"
	
init: generate-credentials docker-pull docker-up dumpautoload generate-new-keys-no-db migrate generate-new-keys-db permissions-seeder storage-links content-rich-seeder restart success 

refresh: flush-postgres init
