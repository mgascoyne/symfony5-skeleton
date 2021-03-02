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
      echo "Mailhog.........: http://${HOST}:8085"
      echo "--------------------------------------------------------------------------------"
    fi
    ;;
  shell)
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS}
    ;;
  exec)
    shift
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "$@"
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "chmod -f -R ugo=rwX ."
    ;;
  phing)
    shift
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "phing $@"
    docker exec ${DOCKER_EXEC_FLAGS} ${PHP_CONTAINER} /bin/bash ${BASH_FLAGS} -c "chmod -f -R ugo=rwX ."
  *)
    echo "Usage: $0 status|shell|exec <command>|phing <target>"
    ;;
esac
