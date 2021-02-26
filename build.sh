#!/usr/bin/env bash
#
# Build script for Symfony skeleton project
# Used inside Virtualbox
#
# @author Marcel Gascoyne <marcel@gascoyne.de>

set -a

source /app/.env
source /app/.env.vagrant

PHP_CONTAINER=${CONTAINER_PREFIX}-php

if [ -z "${DOCKER_EXEC_FLAGS}" ]; then
  DOCKER_EXEC_FLAGS="-it"
fi

if [ -z "${BASH_FLAGS}" ]; then
  BASH_FLAGS="-l -i"
fi

case "$1" in
  status)
    if [ -z `docker ps -f status=running | grep ${PROJECT}_php` ]; then
      echo "--------------------------------------------------------------------------------"
      echo "No services running."
      echo "--------------------------------------------------------------------------------"
    else
      echo "--------------------------------------------------------------------------------"
      echo "Available services"
      echo "--------------------------------------------------------------------------------"
      echo "Application.....: http://${HOST}"
      echo "Varnish.........: http://${HOST}:8080"
      echo "Nginx...........: http://${HOST}:8081"
      echo "PhpMyAdmin......: http://${HOST}:8082"
      echo "Mongo Express...: http://${HOST}:8083"
      echo "Portainer.......: http://${HOST}:8084"
      echo "--------------------------------------------------------------------------------"
    fi
    ;;
  shell)
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS}
    ;;
  exec)
    shift
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "$@"
    ;;
  createdb)
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "php bin/console doctrine:database:create"
    ;;
  dropdb)
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "php bin/console doctrine:database:drop --if-exists --force"
    ;;
  recreatedb)
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "php bin/console doctrine:database:drop --if-exists --force"
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "php bin/console doctrine:database:create"
    ;;
  fixtures)
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "php bin/console doctrine:fixtures:load -n"
    ;;
  migratedb)
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "php bin/console doctrine:migrations:migrate -n"
    ;;
  build)
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "composer install"
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "yarn --no-bin-links --non-interactive --no-progress install"
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "yarn --non-interactive  --no-progress run dev"
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "php bin/console doctrine:cache:clear-metadata"
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "php bin/console doctrine:cache:clear-query"
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "php bin/console doctrine:cache:clear-result"
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "php bin/console doctrine:migrations:migrate -n"

    ;;
  rebuild)
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "composer install"
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "yarn --no-bin-links --non-interactive --no-progress install"
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "yarn --non-interactive  --no-progress run dev"
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "php bin/console doctrine:cache:clear-metadata"
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "php bin/console doctrine:cache:clear-query"
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "php bin/console doctrine:cache:clear-result"
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "php bin/console doctrine:database:drop --if-exists --force"
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "php bin/console doctrine:database:create"
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "php bin/console doctrine:migrations:migrate -n"
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "php bin/console doctrine:fixtures:load -n"
    ;;

  *)
    echo "Usage: $0 status|shell|exec|createdb|dropdb|recreatedb|fixtures|migratedb|build|rebuild"
    ;;
esac
