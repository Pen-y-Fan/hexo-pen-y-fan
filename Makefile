# Usage:

# Check your user ID and update UID, if different
UID = 1000

# make up - starts the docker-compose in the same directory in demon (background)
# make up-f - start the docker-compose in foreground (useful for error messages)
# make down - stops the docker-compose
# make server - same as make up
# make generate - runs hexo generate as the standard user
# make build - alias for make generate
# make shell - opens a shell terminal in the running node container as a standard user
# make chown - runs chown, as root user to reset the ownership of all folders to the UID

up:
	docker-compose up --build --remove-orphans -d server
up-f:
	docker-compose up --build --remove-orphans server
down:
	docker-compose down --remove-orphans
server:
	docker-compose up --build --remove-orphans -d server
generate:
	docker-compose run -u ${UID}:${UID} --rm generate
build:
	docker-compose run -u ${UID}:${UID} --rm generate
hexo:
	docker-compose exec -u ${UID}:${UID} server npx hexo new $(new)

shell:
	docker-compose exec -u ${UID}:${UID} server /bin/sh

chown:
	docker-compose exec -u 0:0 server chown -R ${UID}:${UID} ./










