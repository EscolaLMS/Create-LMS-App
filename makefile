bash:
	- docker-compose exec -u 1000 api bash

dumpautoload: 
	- docker-compose exec -u 1000 api bash -c "composer dumpautoload"

generate-new-keys:
	- docker-compose exec -u 1000 api bash -c "php artisan key:generate"
	- docker-compose exec -u 1000 api bash -c "php artisan passport:keys --force"
	- docker-compose exec -u 1000 api bash -c "php artisan passport:client --personal --no-interaction"

migrate: 
	- docker-compose exec -u 1000 api bash -c "php artisan migrate"

permissions-seeder: 
	- docker-compose exec -u 1000 api bash -c "php artisan db:seed --class=PermissionsSeeder"

content-seeder: 
	- docker-compose exec -u 1000 api bash -c "php artisan db:seed"

docker-up:
	- docker-compose up -d	

docker-down:	
	- docker-compose stop

restart: 
	- docker-compose stop && docker-compose up -d	

h5p-seed:
	- docker-compose exec -u 1000 api bash -c "php artisan db:seed --class=H5PLibrarySeeder"
	- docker-compose exec -u 1000 api bash -c "php artisan db:seed --class=H5PContentSeeder"
	- docker-compose exec -u 1000 api bash -c "php artisan db:seed --class=H5PContentCoursesSeeder"

storage-links:
	- docker-compose exec -u 1000 api bash -c "php artisan storage:link"
	- docker-compose exec -u 1000 api bash -c "php artisan h5p:storage-link"

success: 
	- @echo "Wellms is installed succesfully"
	- @echo "Admin panel http://admin.wellms.localhost"
	- @echo "Demo http://app.wellms.localhost"
	- @echo "API REST http://api.wellms.localhost/api/documentation"
	- @echo "Credentials for admin are username: admin@escola-lms.com password: secret"
	- @echo "Credentials for student are username: student@escola-lms.com password: secret"
	- @echo "Emails are not sent. See http://mailhog.wellms.localhost mailhog to details"
	- @echo "All productions changes must be set in .env file"
	- @echo "Run 'make bash' to lanuch bash mode, where you can use all 'artisan' commands"	
	- @echo "if you need to attach your domain just change CaddyFiles"
	
init: docker-up dumpautoload generate-new-keys migrate generate-new-keys permissions-seeder storage-links content-seeder restart success 

