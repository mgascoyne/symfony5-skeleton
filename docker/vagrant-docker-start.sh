#!/usr/bin/env bash
#
# Provisioning script for Symfony skeleton project
#
# @author Marcel Gascoyne <marcel@gascoyne.de>

set -a

source /app/.env
source /app/.env.vagrant

cd ${PROJECT_DIR}
sudo chmod -R ugo=rwX ${DOCKER_DATA}

if [ -z `docker ps -f status=running | grep ${PROJECT}_php` ]; then
  docker-compose -p ${PROJECT} -f "${DOCKER_DIR}/docker-compose-${ENV}.yml" up -d ${COMPOSE_FLAGS}
fi

./build.sh status
