#!/bin/bash

source /vagrant/setenv.c

ifconfig ${sms_eth_internal} ${sms_ip} netmask ${internal_netmask} up 


# Configuração do xCAT
chdef -t site dhcpinterfaces="xcatmn|${sms_eth_internal}"  

# Removendo caracteres de retorno de carro
iso_path=/vagrant 

# Baixando a ISO do CentOS
#wget --no-check-certificate -O ${iso_path}/CentOS-7-x86_64-DVD-1908.iso https://vault.centos.org/7.7.1908/isos/x86_64/CentOS-7-x86_64-DVD-1908.iso
wget https://vault.centos.org/7.7.1908/isos/x86_64/CentOS-7-x86_64-DVD-1908.iso $iso_path --no-check-certificate  
mv CentOS-7-x86_64-DVD-1908.iso $iso_path 


# Configuração do xCAT para usar a ISO
copycds ${iso_path}/CentOS-7-x86_64-DVD-1908.iso 

# Definindo o diretório CHROOT
export CHROOT=/install/netboot/centos7.7/x86_64/compute/rootimg/  

# Gerando imagem para netboot
genimage centos7.7-x86_64-netboot-compute 

# Habilitando o repositório base no CHROOT
yum-config-manager --installroot=$CHROOT --enable base 

# Copiando repositórios para o CHROOT
cp /etc/yum.repos.d/OpenHPC.repo $CHROOT/etc/yum.repos.d 
cp /etc/yum.repos.d/epel.repo $CHROOT/etc/yum.repos.d 

# Instalando pacotes no CHROOT
yum -y --installroot=$CHROOT install ohpc-base-compute 
yum -y --installroot=$CHROOT install ohpc-slurm-client  
yum -y --installroot=$CHROOT install ntp 
yum -y --installroot=$CHROOT install kernel  
yum -y --installroot=$CHROOT install lmod-ohpc 

# Configurando NFS no CHROOT
echo "${sms_ip}:/home /home nfs nfsvers=3,nodev,nosuid 0 0" >> $CHROOT/etc/fstab 
echo "${sms_ip}:/opt/ohpc/pub /opt/ohpc/pub nfs nfsvers=3,nodev 0 0" >> $CHROOT/etc/fstab 

# Configurando exportações NFS
echo "/home *(rw,no_subtree_check,fsid=10,no_root_squash)" >> /etc/exports 
echo "/opt/ohpc/pub *(ro,no_subtree_check,fsid=11)" >> /etc/exports 

# Reiniciando e habilitando o servidor NFS
exportfs -a 
systemctl restart nfs-server 
systemctl enable nfs-server 

# Habilitando o serviço NTP no CHROOT
chroot $CHROOT systemctl enable ntpd 
echo "server ${sms_ip}" >> $CHROOT/etc/ntp.conf 

# Configurando PAM para o SLURM
echo "account required pam_slurm.so" >> $CHROOT/etc/pam.d/sshd 

echo "FIM script 02" >> ~/log
