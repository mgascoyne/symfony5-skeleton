#!/usr/bin/env bash
#
# Yachtboerse 24
#
# Bash functions for Docker management
#
# Copyright (C) 2021 Marcel Gascoyne
# All rights reserved

FUNCTIONS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Get operating system identifier
getOS()
{
  echo $(uname -s)
}

# Check if Docker stack is running
isDockerRunning()
{
  if [ ! -f "${PROJECT_DIR}/.docker-interface" ]; then
    return 1
  fi

  return 0
}

# Get next available loopback interface name
getNextLinuxLoopbackInterface()
{
  IFNAME=lo
  IFALIAS=0

  while `ifconfig | grep -q "${IFNAME}:${IFALIAS}"`; do
    ((IFALIAS++))
  done

  echo "${IFNAME}:${IFALIAS}"
}

# Create new Linux network interface
#
# $1 Interface name
# $2 IP address
createLinuxInterface()
{
  IFNAME=$1
  IPADDR=$2

  if [ $# -ne 2 ]; then
    echo "createLinuxInterface(): Wrong numer of arguments. Exit."
    return 1
  fi

  sudo ifconfig ${IFNAME} ${IPADDR} up

  return $?
}

# Remove Linux network interface
#
# $1 Interface name
removeLinuxInterface()
{
  IFNAME=$1

  if [ $# -ne 1 ]; then
    echo "removeLinuxInterface(): Wrong number of arguments. Exit."
    return 1
  fi

  sudo ifconfig ${IFNAME} down

  return $?
}

# Add IP alias to Darwin network interface
#
# $1 Interface name
# $2 IP address
addDarwinIPAlias()
{
  IFNAME=$1
  IPADDR=$2

  if [ $# -ne 2 ]; then
    echo "addDarwinIPAlias(): Wrong number of arguments. Exit."
    return 1
  fi

  sudo ifconfig ${IFNAME} alias ${IPADDR} 255.255.255.0
}

# Remove IP alias from Darwin network interface
#
# $1 Interface name
# $2 IP address
removeDarwinIPAlias()
{
  IFNAME=$1
  IPADDR=$2

  if [ $# -ne 2 ]; then
    echo "removeDarwinIPAlias(): Wrong number of arguments. Exit."
    return 1
  fi

  sudo ifconfig ${IFNAME} -alias ${IPADDR}

  return $?
}

# Save Docker interface to file
#
# $1 Interface name
saveDockerInterfaceName()
{
  IFNAME=$1

  if [ $# -ne 1 ]; then
    echo "saveDockerInterfaceName(): Wrong number of arguments. Exit."
    return 1
  fi

  echo "${IFNAME}" > ${PROJECT_DIR}/.docker-interface
}

# Load Docker interface name from file
loadDockerInterfaceName()
{
  if ! isDockerRunning; then
    return 1
  fi

  echo `cat ${PROJECT_DIR}/.docker-interface`

  return 0
}

# Remove Docker interface file
removeDockerInterfaceFile()
{
  if [ ! -f "${PROJECT_DIR}/.docker-interface" ]; then
    return 1
  fi

  rm .docker-interface

  return $?
}

# Add /etc/hosts entry
#
# $1 Hostname
# $2 IP address
addHostsEntry() {
  HOST=$1
  IPADDR=$2

  if [ $# -ne 2 ]; then
    echo "addHostsEntry(): Wrong number of arguments. Exit."
    return 1
  fi

  HOSTS_LINE="${IPADDR} ${HOST}"

  if [ ! -n "$(grep ${HOST} /etc/hosts)" ]; then
    echo "Adding ${HOST} with IP ${IPADDR} to /etc/hosts";
    sudo -- bash -c -e "echo '$HOSTS_LINE' >> /etc/hosts";

    if [ ! -n "$(grep ${HOST} /etc/hosts)" ]; then
      echo "Failed to add ${HOST} with IP ${IPADDR} to /etc/hosts.";
      return 1
    fi
  fi

  return 0
}

# Remove entry from /etc/hosts
#
# $1 Hostname
removeHostsEntry() {
  HOST=$1

  if [ $# -ne 1 ]; then
    echo "removeHostsEntry(): Wrong number of arguments. Exit."
    return 1
  fi

  if [ -n "$(grep ${HOST} /etc/hosts)" ]; then
    echo "Removing ${HOST} from /etc/hosts"
    sudo sed -i".bak" "/${HOST}/d" /etc/hosts
  else
    echo "${HOST} not found in /etc/hosts, cannot remove.";
    return 1
  fi

  return $?
}

# Start bash inside given Docker container
#
# $1 Container name
startDockerShell()
{
  CONTAINER=$1

  if ! isDockerRunning; then
    echo "Docker stack not running. Exit."
    return 1
  fi

  if [ $# -ne 1 ]; then
    echo "startDockerShell(): Wrong number of arguments. Exit."
    return 1
  fi

  cd ${PROJECT_DIR}
  docker exec -it ${CONTAINER} /bin/bash -l -i

  return $?
}

# Exec command in given Docker container
#
# $1 Container name
# $@ Command and arguments
execDocker()
{
  CONTAINER=$1

  if ! isDockerRunning; then
    echo "Docker stack not running. Exit."
    return 1
  fi

  if [ $# -lt 2 ]; then
    echo "execDocker(): Wrong number of arguments. Exit."
    return 1
  fi

  shift
  CMD=$@

  cd ${PROJECT_DIR}
  docker exec -it ${CONTAINER} /bin/bash -l -i -c "$CMD"
  docker exec -it ${CONTAINER} /bin/bash -l -i -c "chmod -f -R ugo=rwX ."


  return $?
}

# Run Phing in given Docker container
#
# $1 Container name
# $@ Arguments
runPhing()
{
  CONTAINER=$1

  if ! isDockerRunning; then
    echo "Docker stack not running. Exit."
    return 1
  fi

  if [ $# -lt 1 ]; then
    echo "runPhing(): Wrong number of arguments. Exit."
    return 1
  fi

  shift
  ARGS=$@

  cd ${PROJECT_DIR}
  docker exec -it ${CONTAINER} /bin/bash -l -i -c "phing $ARGS"
  docker exec -it ${CONTAINER} /bin/bash -l -i -c "chmod -f -R ugo=rwX ."

  return $?
}

# Show status of docker stack
status()
{
  cat ${FUNCTIONS_DIR}/banner.txt
  echo

  if isDockerRunning; then
    echo "--------------------------------------------------------------------------------"
    echo "Available services from Docker stack"
    echo "--------------------------------------------------------------------------------"
    echo "Application.....: http://${HOST}"
    echo "Varnish.........: http://${HOST}:8080"
    echo "Nginx...........: http://${HOST}:8081"
    echo "PhpMyAdmin......: http://${HOST}:8082"
    echo "Mongo Express...: http://${HOST}:8083"
    echo "Portainer.......: http://${HOST}:8084"
    echo "Mailhog.........: http://${HOST}:8085"
    echo "--------------------------------------------------------------------------------"
  else
    echo "--------------------------------------------------------------------------------"
    echo "Docker stack stopped."
    echo "--------------------------------------------------------------------------------"
  fi
}
