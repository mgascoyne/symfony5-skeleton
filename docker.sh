#!/usr/bin/env bash
#
# Management script for Docker stack
#
# @author Marcel Gascoyne <marcel@gascoyne.de>

set -a

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DOCKER_DIR=${PROJECT_DIR}/docker
DOCKER_DATA=${PROJECT_DIR}/docker-data

source ${PROJECT_DIR}/.env
source ${PROJECT_DIR}/docker/functions.inc.sh

OS=$(getOS)

FORCE="false"
BUILD="false"
COMPOSE_FLAGS=""
ENV=dev
POSITIONAL=()

PHP_CONTAINER=${CONTAINER_PREFIX}-php

while [[ $# -gt 0 ]]
do
  param="$1"

  case $param in
    --force|-f)
      FORCE="true"
      shift
      ;;
    --build|-b)
      BUILD="true"
      shift
      ;;
    --env|-e)
      if [ $# -lt 2 ]; then
        echo "--env Parameter needs environment"
        exit 1
      fi
      ENV=$2
      shift
      shift
      ;;
    *)
      POSITIONAL+=("$1")
      shift
      ;;
  esac
done

set -- "${POSITIONAL[@]}"

case $1 in
  start)
    if isDockerRunning && [ $FORCE != "true" ]; then
      echo "Docker stack already started. Exit."
      exit 1
    fi

    if [ "${OS}" == "Linux" ]; then
      IFNAME=$(getNextLinuxLoopbackInterface)
      echo "Creating new interface ${IFNAME} with IP ${IPADDR}"
      createLinuxInterface ${IFNAME} ${IPADDR}
      saveDockerInterfaceName ${IFNAME}
    fi

    if [ "${OS}" == "Darwin" ]; then
      IFNAME=lo0
      echo "Creating new alias for ${IFNAME} with IP ${IPADDR}"
      addDarwinIPAlias ${IFNAME} ${IPADDR}
      saveDockerInterfaceName ${IFNAME}
    fi

    if [ "$BUILD" == "true" ]; then
      COMPOSE_FLAGS="${COMPOSE_FLAGS} --build"
    fi

    sudo mkdir -p ${DOCKER_DATA}/data
    sudo mkdir -p ${DOCKER_DATA}/mariadb
    sudo mkdir -p ${DOCKER_DATA}/mongo
    sudo mkdir -p ${DOCKER_DATA}/portainer
    sudo mkdir -p ${DOCKER_DATA}/redis
    sudo chmod -R ugo=rwX ${DOCKER_DATA}

    docker-compose -p ${PROJECT} -f "${DOCKER_DIR}/docker-compose-${ENV}.yml" up -d ${COMPOSE_FLAGS}
    addHostsEntry ${HOST} ${IPADDR}
    status
    ;;
  stop)
    if ! isDockerRunning; then
      echo "Docker stack not running. Exit."
      exit 1
    fi

    docker-compose -p ${PROJECT} -f "${DOCKER_DIR}/docker-compose-${ENV}.yml" down ${COMPOSE_FLAGS}

    removeHostsEntry ${HOST}

    IFNAME=$(loadDockerInterfaceName)
    removeDockerInterfaceFile

    if [ "${OS}" == "Linux" ]; then
      echo "Removing interface ${IFNAME} with IP ${IPADDR}"
      removeLinuxInterface ${IFNAME}
    fi

    if [ "${OS}" == "Darwin" ]; then
      echo "Removing alias from interface ${IFNAME} (IP ${IPADDR})"
      removeDarwinIPAlias ${IFNAME} ${IPADDR}
    fi

    status
    ;;
  restart)
    START_FLAGS=""
    if [ "$BUILD" == "true" ]; then
      START_FLAGS="--build"
    fi

    if [ ! -z "$ENV" ]; then
      START_FLAGS="${START_FLAGS} --env ${ENV}"
    fi

    $0 stop
    $0 start ${START_FLAGS}
    ;;
  status)
    status
    ;;
  shell)
    startDockerShell ${PHP_CONTAINER}
    ;;
  exec)
    shift
    execDocker ${PHP_CONTAINER} "$@"
    ;;
  createdb)
    createDatabase ${PHP_CONTAINER}
    ;;
  dropdb)
    dropDatabase ${PHP_CONTAINER}
    ;;
  recreatedb)
    dropDatabase ${PHP_CONTAINER}
    createDatabase ${PHP_CONTAINER}
    ;;
  fixtures)
    loadFixtures ${PHP_CONTAINER}
    ;;
  migratedb)
    migrateDatabase ${PHP_CONTAINER}
    ;;
  build)
    build ${PHP_CONTAINER}
    ;;
  rebuild)
    rebuild ${PHP_CONTAINER}
    ;;
  *)
    echo "Usage: $0 start [--build|-b]|stop|restart|status|shell|exec <command>|createdb|dropdb|recreatedb|fixtures|migratedb|build|rebuild [--env|-e <environment>] [--force|-f]"
    ;;
esac
