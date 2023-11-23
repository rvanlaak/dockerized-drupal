up:
	docker compose up -d --remove-orphans

upb:
	docker compose up -d --build --remove-orphans

setup:
	docker run --rm -v ${PWD}:/app -w /app composer create-project drupal/recommended-project brewadmin --ignore-platform-reqs

