#!/bin/bash

set -e
cd ~/gpdb
mkdir -p gpconfigs
source /usr/local/gpdb/greenplum_path.sh
cp $GPHOME/docs/cli_help/gpconfigs/gpinitsystem_config \
    ~/gpdb/gpconfigs/gpinitsystem_config
cd gpconfigs
sudo ldconfig

input="declare -a DATA_DIRECTORY=(/data1/primary /data1/primary /data1/primary\
 /data2/primary /data2/primary /data2/primary)"
output="declare -a DATA_DIRECTORY=(/data1/primary /data1/primary\ 
 /data1/primary /data1/primary /data2/primary /data2/primary\ 
 /data2/primary /data2/primary)"
sed -i s+'${input}'+'${output}'+g gpinitsystem_config
sed -i s/MASTER_HOSTNAME=mdw/MASTER_HOSTNAME=mycluster-master/g \
    gpinitsystem_config
    
awk '/^[[:space:]]*($|#)/{next} /mycluster/{print $2;}' /etc/hosts > \
    hostfile_gpinitsystem
cd ../
yes | gpinitsystem -c gpconfigs/gpinitsystem_config -h \
    gpconfigs/hostfile_gpinitsystem
