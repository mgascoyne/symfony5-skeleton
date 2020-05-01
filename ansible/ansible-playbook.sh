#!/usr/bin/env bash
#
# Ansible playbook runner
#
# Installs Ansible if not already installed

# @author Marcel Gascoyne <marcel@gascoyne.de>

if [ $(dpkg-query -W -f='${Status}' ansible 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    echo "Add Ansible APT repository..."
    export DEBIAN_FRONTEND=noninteractive
    apt-get install -qq apt-transport-https ca-certificates curl software-properties-common &> /dev/null || exit 1
    apt-add-repository -y ppa:ansible/ansible &> /dev/null || exit 1

    echo "Update APT repositories..."
    apt-get update -qq

    echo "Installing Ansible"
    apt-get install -qq ansible &> /dev/null || exit 1
    echo "Ansible installed"
fi

cd /app/ansible
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook $*
