#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

        # grab user dir
VMDIR=$(getent passwd $SUDO_USER | cut -d: -f6)"/VMs/Class"
mkdir -p $VMDIR
cd $VMDIR

apt-get install virtualbox
apt-get install terraform

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

apt update && apt install terraform

wget "https://drive.google.com/uc?export=download&id=14ATyECEOm1G9cM-0RU7oHDePJr6tTqDF" -O main.tf
wget "https://drive.google.com/u/0/uc?id=1Axq-q0OjuRUJ-zUHXZwH3Ni5lhHlbTqn&export=download&confirm=t" -O Ubuntu.ova

terraform -chdir=$(pwd) init
# auto start terraform
echo 'yes' | terraform apply

#give ownership to current user for manual cleanup
chown -R $SUDO_USER $VMDIR/../../VMs
