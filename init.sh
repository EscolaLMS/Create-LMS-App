#!/bin/sh
# API create 
create_api()
{
    docker-compose stop
    docker-compose up -d php 
    FILE=api/composer.json
    if [ -f "$FILE" ]; then
        echo "$FILE exists. Skiping installation of API "
    else
        docker-compose exec php bash -c "composer self-update"
        docker-compose exec php bash -c "composer create-project escolalms/api ."
        cd api
        make init
        docker-compose exec escola_lms_app bash -c "php artisan h5p:storage-link"
        cd ..
    fi
   
}

# create admin panel 
create_admin()
{
    FILE=admin/package.json
    if [ -f "$FILE" ]; then
        echo "$FILE exists. Skiping installation of Admin Panel "
    else 
        git clone https://github.com/EscolaLMS/Admin.git admin 
    fi

    FILE=admin/dist/index.html
    if [ -f "$FILE" ]; then
        echo "$FILE exists. Skiping bulding of Admin Panel "
    else 
        cd admin 
        npm i 
        BASE_PATH=/ REACT_APP_API_URL='http://localhost:1000' npm run build  
        cd ..
    fi
    
}
# create admin panel 
create_front()
{
    FILE=front/package.json

    if [ -f "$FILE" ]; then
        echo "$FILE exists. Skiping installation of Admin Panel "
    else 
        git clone https://github.com/EscolaLMS/Front.git front 
    fi

    FILE=front/build/index.html
    if [ -f "$FILE" ]; then
        echo "$FILE exists. Skiping bulding of front "
    else 
        cd front 
        npm i 
        REACT_APP_ROUTING_TYPE=BrowserRouter REACT_APP_PUBLIC_API_URL=http://localhost:1000 node_modules/.bin/react-app-rewired build
        cd ..
    fi
    
}

create_server() 
{
    docker-compose stop
    docker-compose up -d front admin
    echo "http://localhost:1000/api/documentation is where API Swagger documentation lives"
    echo "http://localhost:8001 is where admin panel is. Use admin@escola-lms.com as username and secret as password to log in"
    echo "http://localhost:8002 is where demo is. Use student@escola-lms.com as username and secret as password to log in"
}


create_api
create_admin
create_front
create_server
