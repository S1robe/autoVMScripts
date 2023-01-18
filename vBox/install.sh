#!/bin/bash

#user than ran the script's id (normal user)
USER_ID=$(id -u $SUDO_USER)

# Shed su perms when required
RUN="setpriv --reuid=$USER_ID --regid=$USER_ID --reset-env --init-groups"

# grab user dir 
VMDIR=$(getent passwd $SUDO_USER | cut -d: -f6)"/VMs/Class" 

# ensure running as root for installing things
if [ $EUID != 0 ];
then
   echo "Please run this script as root"
   exit 1
fi 
#--------------------------------------------


# make directories as user
$RUN mkdir -p $VMDIR
cd $VMDIR
#--------------------------


# install required software
#---------------------------------------------------------
#apt-get install -y virtualbox

#wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

#echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

#apt update && apt install -y terraform
#----------------------------------------------------------

# Download necessary files
$RUN wget "https://drive.google.com/uc?export=download&id=14ATyECEOm1G9cM-0RU7oHDePJr6tTqDF" -O main.tf
$RUN wget "https://drive.google.com/u/0/uc?id=1Axq-q0OjuRUJ-zUHXZwH3Ni5lhHlbTqn&export=download&confirm=t" -O Ubuntu.ova
# ----------------------------------------------------------

# Init Terraform
$RUN terraform -chdir=$(pwd) init

# auto start terraform to install Ubuntu.ova
echo 'yes' | $RUN terraform apply
