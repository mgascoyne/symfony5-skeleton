#!/usr/bin/env bash
#
# Vagrant provisioning script for Symfony skeleton project
#
# @author Marcel Gascoyne <marcel@gascoyne.de>

export PYTHONUNBUFFERED=1
export ANSIBLE_FORCE_COLOR=1
export DOCKER_DATA=/data
export DOCKER_EXEC_FLAGS="-t"

cd /app/ansible
./ansible-playbook.sh -i inventory development.yml

cd /app

docker-compose up -d
./build.sh rebuild
