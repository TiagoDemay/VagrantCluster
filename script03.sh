#!/bin/bash
echo "account required pam_slurm.so" >> $CHROOT/etc/pam.d/sshd
source /vagrant/setenv.c 
yum -y install ohpc-nagios 
yum -y --installroot=$CHROOT install nagios-plugins-all-ohpc nrpe-ohpc 
chroot $CHROOT systemctl enable nrpe 
perl -pi -e "s/^allowed_hosts=/# allowed_hosts=/" $CHROOT/etc/nagios/nrpe.cfg 
echo "nrpe 5666/tcp # NRPE" >> $CHROOT/etc/services 
echo "nrpe : ${sms_ip} : ALLOW" >> $CHROOT/etc/hosts.allow 
echo "nrpe : ALL : DENY" >> $CHROOT/etc/hosts.allow 
chroot $CHROOT /usr/sbin/useradd -c "NRPE user for the NRPE service" -d /var/run/nrpe -r -g nrpe -s /sbin/nologin nrpe 
chroot $CHROOT /usr/sbin/groupadd -r nrpe 

export sms_name=sms-host

mv /etc/nagios/conf.d/services.cfg.example /etc/nagios/conf.d/services.cfg

mv /etc/nagios/conf.d/hosts.cfg.example /etc/nagios/conf.d/hosts.cfg 

num_computes=$(echo $num_computes | tr -d '\r') 

perl -pi -e "s/HOSTNAME1/${c_name[0]}/" /etc/nagios/conf.d/hosts.cfg 

perl -pi -e "s/HOSTNAME2/${c_name[1]}/" /etc/nagios/conf.d/hosts.cfg 

perl -pi -e "s/HOST1_IP/${c_ip[0]}/" /etc/nagios/conf.d/hosts.cfg 

perl -pi -e "s/HOST2_IP/${c_ip[1]}/" /etc/nagios/conf.d/hosts.cfg 

perl -pi -e "s/ \/bin\/mail/ \/usr\/bin\/mailx/g" /etc/nagios/objects/commands.cfg 

perl -pi -e "s/nagios\@localhost/root\@${sms_name}/" /etc/nagios/objects/contacts.cfg 

echo command[check_ssh]=/usr/lib64/nagios/plugins/check_ssh localhost >> $CHROOT/etc/nagios/nrpe.cfg 

htpasswd -bc /etc/nagios/passwd nagiosadmin ${nagios_web_password} 

systemctl enable nagios.service 

systemctl start nagios 

chmod u+s `which ping` 

yum -y install ohpc-ganglia 

yum -y --installroot=$CHROOT install ganglia-gmond

yum -y --installroot=$CHROOT install ganglia-gmetad

cp /opt/ohpc/pub/examples/ganglia/gmond.conf /etc/ganglia/gmond.conf 

perl -pi -e "s/<sms>/${sms_name}/" /etc/ganglia/gmond.conf 

cp /etc/ganglia/gmond.conf $CHROOT/etc/ganglia/gmond.conf 

echo "gridname MySite" >> /etc/ganglia/gmetad.conf 

systemctl enable gmond 

systemctl enable gmetad 

systemctl start gmond 

systemctl start gmetad 

chroot $CHROOT systemctl enable gmond 

systemctl try-restart httpd 

 
yum -y install clustershell-ohpc 

cd /etc/clustershell/groups.d 

mv local.cfg local.cfg.orig 

echo "adm: ${sms_name}" > local.cfg 
echo "compute: compute00" >> local.cfg 
echo "compute: compute01" >> local.cfg 
echo "all: @adm,@compute" >> local.cfg 

yum -y install nhc-ohpc 

yum -y --installroot=$CHROOT install nhc-ohpc 

echo "HealthCheckProgram=/usr/sbin/nhc" >> /etc/slurm/slurm.conf 
echo "HealthCheckInterval=300" >> /etc/slurm/slurm.conf # execute every five minutes 

mkdir -p /install/custom/netboot 

chdef -t osimage -o centos7.7-x86_64-netboot-compute synclists="/install/custom/netboot/compute.synclist"  

echo "/etc/passwd -> /etc/passwd" > /install/custom/netboot/compute.synclist 
echo "/etc/group -> /etc/group" >> /install/custom/netboot/compute.synclist 
echo "/etc/shadow -> /etc/shadow" >> /install/custom/netboot/compute.synclist 
echo "/etc/slurm/slurm.conf -> /etc/slurm/slurm.conf " >> /install/custom/netboot/compute.synclist 
echo "/etc/munge/munge.key -> /etc/munge/munge.key " >> /install/custom/netboot/compute.synclist
 
updatenode compute -F
 
packimage centos7.7-x86_64-netboot-compute  

mkdef -t node compute00 groups=compute,all ip=${c_ip[0]} mac=${c_mac[0]} netboot=xnba arch=x86_64 bmc=${c_bmc[0]} bmcusername=${bmc_username} bmcpassword=${bmc_password} mgt=ipmi serialport=0 serialspeed=115200 

mkdef -t node compute01 groups=compute,all ip=${c_ip[1]} mac=${c_mac[1]} netboot=xnba arch=x86_64 bmc=${c_bmc[1]} bmcusername=${bmc_username} bmcpassword=${bmc_password} mgt=ipmi serialport=0 serialspeed=115200  
 

chdef -t site domain=${domain_name} 

chdef -t site master=${sms_ip} 

chdef -t site nameservers=${sms_ip} 

makehosts 

makenetworks 

makedhcp -n 

makedns -n 

nodeset compute osimage=centos7.7-x86_64-netboot-compute 

echo "Finalizamos boa parte das configurações das máquinas e agora voltamos a executar os comandos na máquina física."  


echo "FIM script 03" >> ~/log
