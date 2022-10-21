export DOCKER_USER=$(id -u)

APP_URL ?= "http://api.wellms.localhost"
ADMIN_URL ?= "http://admin.wellms.localhost"  
FRONT_URL ?= "http://app.wellms.localhost"  
MAILHOG_URL ?= "http://mailhog.wellms.localhost"  
REPORTBRO_URL ?= "http://reportbro.wellms.localhost"  

NAMESPACE ?= "escolalms"


bash:
	docker-compose exec -u 1000 api bash

generate-credentials:	
	bash ./scripts/credentials.sh

dumpautoload: 
	docker-compose exec -T -u 1000 api bash -c "composer dumpautoload"

generate-new-keys-no-db:
	docker-compose exec -T -u 1000 api bash -c "php artisan key:generate --force --no-interaction"
	docker-compose exec -T -u 1000 api bash -c "php artisan passport:keys --force --no-interaction"

generate-new-keys-db:
	docker-compose exec -T -u 1000 api bash -c "php artisan passport:client --personal --no-interaction"

migrate: 
	docker-compose exec -T -u 1000 api bash -c "php artisan migrate --force --no-interaction"

permissions-seeder: 
	docker-compose exec -T -u 1000 api bash -c "php artisan db:seed --class=PermissionsSeeder --force --no-interaction"

content-seeder: 
	- docker-compose exec -T -u 1000 api bash -c "php artisan db:seed --force --no-interaction"

content-rich-seeder: 
	- docker-compose exec -T -u 1000 api bash -c "php artisan db:seed --class=FullDatabaseSeeder --force --no-interaction"

docker-up:
	docker-compose up -d --remove-orphans	

docker-up-force:
	docker-compose up -d	--force-recreate

docker-down:	
	docker-compose stop

docker-pull:	
	docker-compose pull

docker-update: docker-pull docker-up-force dumpautoload storage-links

restart: 
	docker-compose stop && docker-compose up -d	

h5p-seed:
	- docker-compose exec -T -u 1000 api bash -c "php artisan db:seed --class=H5PLibrarySeeder --force --no-interaction"
	- docker-compose exec -T -u 1000 api bash -c "php artisan db:seed --class=H5PContentSeeder --force --no-interaction"
	- docker-compose exec -T -u 1000 api bash -c "php artisan db:seed --class=H5PContentCoursesSeeder --force --no-interaction"

storage-links:
	- docker-compose exec -T -u 1000 api bash -c "php artisan storage:link --force --no-interaction"
	- docker-compose exec -T -u 1000 api bash -c "php artisan h5p:storage-link"
	
# creates a backup file into `data` folder
# TODO this should be called by user 1000 but there is an issue with volume 
backup-postgres:
	bash scripts/import.sh

# imports database backup from data folder 
# make import BACKUP_FILE=backup-2020-09-15-14:49:22.sql 
# or 
# make import BACKUP_FILE=backup-latest.sql
#import-postgres: backup-postgres

import-postgres: 
	bash scripts/import.sh

flush-postgres: 
	- rm -rf docker/postgres-data	
	- docker-compose down

success: 
	- @echo "Wellms is installed succesfully"
	- @echo "Admin panel $(ADMIN_URL)"
	- @echo "Demo $(FRONT_URL)"
	- @echo "API REST $(APP_URL)/api/documentation"
	- @echo "Credentials for admin are username: admin@escolalms.com password: secret"
	- @echo "Credentials for student are username: student@escolalms.com password: secret"
	- @echo "Emails are not sent. See $(MAILHOG_URL) mailhog for details"
	- @echo "Run 'make bash' to lanuch bash mode, where you can use all 'artisan' commands"	
	
init: generate-credentials docker-pull docker-up dumpautoload generate-new-keys-no-db migrate generate-new-keys-db permissions-seeder storage-links content-seeder restart success 

refresh: flush-postgres init

# minikube

minikube-start:
	minikube start
#	minikube start --memory 8192 --cpus 4

minikube-addons:
	minikube addons enable ingress
	minikube addons enable ingress-dns

minikube-tunnel:
	minikube tunnel

minikube-force-delete:
	minikube delete
	minikube start
#	minikube start --memory 8192 --cpus 4

minikube-init: minikube-start minikube-addons

# k8s 

k8s-generate-yaml:
	./scripts/generate-k8s.sh

k8s-delete: 
	kubectl delete all --all -n $(NAMESPACE)         
	kubectl delete pvc --all -n $(NAMESPACE)     
	kubectl delete pv --all -n $(NAMESPACE)       
	kubectl delete storageclass --all -n $(NAMESPACE)       
	-rm -f k8s/*.yaml
	-minikube ssh "sudo rm -rf /var/lib/postgresql/data"

k8s-apply: 
	kubectl apply -f k8s/namespace.yaml
	kubectl apply -f k8s/configmap.yaml
	kubectl apply -f k8s/deploy-admin.yaml
	kubectl apply -f k8s/deploy-backend.yaml
	kubectl apply -f k8s/deploy-frontend.yaml
	kubectl apply -f k8s/deploy-mailhog.yaml
	kubectl apply -f k8s/deploy-reportbro.yaml
	kubectl apply -f k8s/deploy-postgres.yaml
	kubectl apply -f k8s/deploy-redis.yaml
	kubectl apply -f k8s/deploy-scheduler-queue.yaml
	kubectl apply -f k8s/volume-backend.yaml
	kubectl apply -f k8s/ingress.yaml

k8s-rebuild: k8s-delete k8s-generate-yaml k8s-apply

k8s-init: k8s-generate-yaml k8s-apply

#k8s-rebuild: minikube-init k8s-delete k8s-generate-yaml k8s-apply minikube-tunel
#k8s-init: minikube-init k8s-generate-yaml k8s-apply minikube-tunel
