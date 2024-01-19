include .env
export

up: .build
	docker compose up -d --remove-orphans
	@echo "Application available on http://localhost:${APP_PORT} 🎉"

.build:
	docker compose build
	docker compose run --rm app composer install
	touch .build
