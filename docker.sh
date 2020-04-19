#!/usr/bin/env bash
#
# Management script for Docker stack
#
# @author Marcel Gascoyne <marcel@gascoyne.de>

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${PROJECT_DIR}/.env
source ${PROJECT_DIR}/docker/functions.inc.sh

OS=$(getOS)
PHP_CONTAINER=${CONTAINER_PREFIX}-php

case "$1" in
  start)
    if isDockerRunning && [ "$2" != "--force" ] && [ "$3" != "--force" ]; then
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

    if [ $# -eq 2 ] && [ "$2" == "--build" ]; then
      COMPOSE_FLAGS="--build"
    else
      COMPOSE_FLAGS=""
    fi

    docker-compose up -d ${COMPOSE_FLAGS}
    addHostsEntry ${HOST} ${IPADDR}
    status
    ;;
  stop)
    if ! isDockerRunning; then
      echo "Docker stack not running. Exit."
      exit 1
    fi

    docker-compose down
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
    $0 stop
    $0 start
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
    echo "Usage: $0 start [--build]|stop|restart|status|shell|exec <command>|createdb|dropdb|recreatedb|fixtures|migratedb|build|rebuild"
    ;;
esac
