
bash:
	- docker-compose exec -u 1000 api bash

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
	- docker-compose up -d	

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
	
init: docker-pull docker-up dumpautoload generate-new-keys-no-db migrate generate-new-keys-db permissions-seeder storage-links content-rich-seeder restart success 

