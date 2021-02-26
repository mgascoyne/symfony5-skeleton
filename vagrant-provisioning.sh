#!/usr/bin/env bash
#
# Vagrant provisioning script for Symfony skeleton project
#
# @author Marcel Gascoyne <marcel@gascoyne.de>

set -a

source /app/.env
source /app/.env.vagrant

cd /app/ansible
./ansible-playbook.sh -i inventory development.yml

cd ${PROJECT_DIR}

sudo mkdir -p ${DOCKER_DATA}/data
sudo mkdir -p ${DOCKER_DATA}/mariadb
sudo mkdir -p ${DOCKER_DATA}/mongo
sudo mkdir -p ${DOCKER_DATA}/portainer
sudo mkdir -p ${DOCKER_DATA}/redis
sudo chmod -R ugo=rwX ${DOCKER_DATA}

docker-compose -p ${PROJECT} -f "${DOCKER_DIR}/docker-compose-${ENV}.yml" up -d ${COMPOSE_FLAGS}

./build.sh rebuild
