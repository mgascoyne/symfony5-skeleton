#!/usr/bin/env bash
#
# Provisioning script for Symfony skeleton project
#
# @author Marcel Gascoyne <marcel@gascoyne.de>

export IPADDR=192.168.50.10
export DOCKER_DATA=/data

mkdir -p /data

cd /app

if [ -z `docker-compose ps -q php` ] || [ -z `docker ps -q --no-trunc | grep $(docker-compose ps -q php)` ]; then
  docker-compose up -d
fi

./build.sh status
