#!/usr/bin/env bash
#
# Bash functions
#
# @author Marcel Gascoyne <marcel@gascoyne.de>

# Get operating system identifier
getOS()
{
  echo $(uname -s)
}

# Check if Docker stack is running
isDockerRunning()
{
  if [ ! -f ".docker-interface" ]; then
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

  echo "${IFNAME}" > .docker-interface
}

# Load Docker interface name from file
loadDockerInterfaceName()
{
  if ! isDockerRunning; then
    return 1
  fi

  echo `cat .docker-interface`

  return 0
}

# Remove Docker interface file
removeDockerInterfaceFile()
{
  if [ ! -f ".docker-interface" ]; then
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

  docker exec -it ${CONTAINER} /bin/bash -l -i -c "$@"

  return $?
}

# Create database
#
# $1 Container name
createDatabase()
{
  CONTAINER=$1

  if ! isDockerRunning; then
    echo "Docker stack not running. Exit."
    exit 1
  fi

  if [ $# -ne 1 ]; then
    echo "createDatabase(): Wrong number of arguments. Exit."
    return 1
  fi

  execDocker ${CONTAINER} "php bin/console doctrine:database:create"
}

# Migrate database
#
# $1 Container name
migrateDatabase()
{
  CONTAINER=$1

  if ! isDockerRunning; then
    echo "Docker stack not running. Exit."
    exit 1
  fi

  if [ $# -ne 1 ]; then
    echo "migrateDatabase(): Wrong number of arguments. Exit."
    return 1
  fi

  execDocker ${CONTAINER} "php bin/console doctrine:migrations:migrate -n"
}

# Load fixtures
#
# $1 Container name
loadFixtures()
{
  CONTAINER=$1

  if ! isDockerRunning; then
    echo "Docker stack not running. Exit."
    exit 1
  fi

  if [ $# -ne 1 ]; then
    echo "loadFixtures(): Wrong number of arguments. Exit."
    return 1
  fi

  execDocker ${CONTAINER} "php bin/console doctrine:fixtures:load -n"
}

# Drop database
#
# $1 Container name
dropDatabase()
{
  CONTAINER=$1

  if ! isDockerRunning; then
    echo "Docker stack not running. Exit."
    exit 1
  fi

  if [ $# -ne 1 ]; then
    echo "dropDatabase(): Wrong number of arguments. Exit."
    return 1
  fi

  execDocker ${CONTAINER} "php bin/console doctrine:database:drop --if-exists --force"
}

# Normal build
#
# $1 Container name
build()
{
  CONTAINER=$1

  if ! isDockerRunning; then
    echo "Docker stack not running. Exit."
    exit 1
  fi

  if [ $# -ne 1 ]; then
    echo "build(): Wrong number of arguments. Exit."
    return 1
  fi

  execDocker ${CONTAINER} "composer install"
  execDocker ${CONTAINER} "yarn install"
  execDocker ${CONTAINER} "yarn encore dev"
  migrateDatabase ${CONTAINER}
}

# Full rebuild with fresh database and fixtures
#
# $1 Container name
rebuild()
{
  CONTAINER=$1

  if ! isDockerRunning; then
    echo "Docker stack not running. Exit."
    exit 1
  fi

  if [ $# -ne 1 ]; then
    echo "rebuild(): Wrong number of arguments. Exit."
    return 1
  fi

  execDocker ${CONTAINER} "composer install"
  execDocker ${CONTAINER} "yarn install"
  execDocker ${CONTAINER} "yarn encore dev"
  dropDatabase ${CONTAINER}
  createDatabase ${CONTAINER}
  migrateDatabase ${CONTAINER}
  loadFixtures ${CONTAINER}
}
