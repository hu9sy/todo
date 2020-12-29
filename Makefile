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
laravel-install:
	docker-compose exec app composer create-project --prefer-dist laravel/laravel .
fresh:
	docker-compose exec app php artisan migrate:fresh --seed
create:
	@make build
	@make up
	@make laravel-install
	docker-compose exec app php artisan key:generate
	docker-compose exec app php artisan storage:link
	@make fresh
init:
	docker-compose up -d --build
	docker-compose exec app composer install
	docker-compose exec app php artisan key:generate
	docker-compose exec app php artisan storage:link
	@make fresh
restart:
	@make down
	@make up
app:
	docker-compose exec app bash
db:
	docker-compose exec db bash
web:
	docker-compose exec web bash
cache:
	docker-compose exec cache bash
redis:
	docker-compose exec cache redis-cli
sql:
	docker-compose exec db bash -c 'mysql -u $$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE'

