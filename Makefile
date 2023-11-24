up: .build
	docker compose up -d --remove-orphans

.build:
	docker compose build
	docker compose run --rm app composer install
	touch .build
