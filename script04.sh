yum -y install ohpc-autotools
yum -y install EasyBuild-ohpc 
yum -y install hwloc-ohpc
yum -y install spack-ohpc 
yum -y install valgrind-ohpc
yum -y install gnu8-compilers-ohpc
yum -y install llvm5-compilers-ohpc
yum -y install openmpi3-gnu8-ohpc mpich-gnu8-ohpc  
yum -y install ohpc-gnu8-perf-tools
yum -y install lmod-defaults-gnu8-openmpi3-ohpc
systemctl enable munge
systemctl enable slurmctld
systemctl start munge
systemctl start slurmctld
pdsh -w compute0[0-1] systemctl start slurmd
useradd -m test
echo "MERGE:" > syncusers  
echo "/etc/passwd -> /etc/passwd" >> syncusers 
echo "/etc/group -> /etc/group" >> syncusers 
echo "/etc/shadow -> /etc/shadow" >> syncusers
xdcp compute -F syncusers
cp /opt/ohpc/pub/examples/slurm/job.mpi .




