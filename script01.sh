#!/bin/bash

# Instalação do OpenHPC
yum install -y http://build.openhpc.community/OpenHPC:/1.3/CentOS_7/x86_64/ohpc-release-1.3-1.el7.x86_64.rpm

# Instalação do repositório EPEL
yum install -y epel-release

yum -y install yum-utils


# Adicionando repositórios xCAT
wget -P /etc/yum.repos.d https://xcat.org/files/xcat/repos/yum/latest/xcat-core/xcat-core.repo --no-check-certificate
wget -P /etc/yum.repos.d https://xcat.org/files/xcat/repos/yum/xcat-dep/rh7/x86_64/xcat-dep.repo --no-check-certificate

yum -y install ohpc-base 

yum -y install xCAT 


# Carregando configurações do xCAT
source /etc/profile.d/xcat.sh

# Configurando o serviço NTP
systemctl enable ntpd.service
echo "server ${ntp_server}" >> /etc/ntp.conf
systemctl restart ntpd.service

# Instalação e configuração do Slurm
yum -y install ohpc-slurm-server
perl -pi -e "s/ControlMachine=\S+/ControlMachine=${sms_name}/" /etc/slurm/slurm.conf
perl -pi -e "s/Sockets=2/Sockets=1/" /etc/slurm/slurm.conf
perl -pi -e "s/CoresPerSocket=8/CoresPerSocket=2/" /etc/slurm/slurm.conf
perl -pi -e "s/ThreadsPerCore=2/ThreadsPerCore=1/" /etc/slurm/slurm.conf
perl -pi -e "s/NodeName=c\[1-4\]/NodeName=compute0\[0-1\]/" /etc/slurm/slurm.conf
perl -pi -e "s/Nodes=c\[1-4\]/Nodes=compute0\[0-1\]/" /etc/slurm/slurm.conf

# Reiniciando o sistema
#reboot

# Mensagem final
echo "FIM script 01" > ~/log