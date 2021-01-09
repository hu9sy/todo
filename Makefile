up:
	docker-compose up -d
down:
	docker-compose down --remove-orphans
stop:
	docker-compose stop
build:
	docker-compose build --no-cache --force-rm
destroy:
	docker-compose down --rmi all --volumes --remove-orphans
fresh:
	docker-compose exec backend_app php artisan migrate:fresh --seed
init:
	docker-compose up -d --build
	docker-compose exec backend_app composer install
	docker-compose exec backend_app php artisan key:generate
	docker-compose exec backend_app php artisan storage:link
	@make fresh
restart:
	@make down
	@make up
frontend_web:
	docker-compose exec frontend_web sh
backend_web:
	docker-compose exec backend_web sh
backend_app:
	docker-compose exec backend_app bash
db:
	docker-compose exec db bash
cache:
	docker-compose exec cache bash
redis:
	docker-compose exec cache redis-cli
sql:
	docker-compose exec db bash -c 'mysql -u $$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE'
