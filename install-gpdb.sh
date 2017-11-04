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
echo "export MASTER_DATA_DIRECTORY=/data/master/gpseg-1" >> ~/.bashrc
source ~/.bashrc
source /usr/local/gpdb/greenplum_path.sh
createdb

echo "export MASTER_DATA_DIRECTORY=/data/master/gpseg-1" >> ~/.bashrc
source ~/.bashrc

cd ~/gpdb/build
wget 'http://apache.org/dyn/closer.cgi?filename=madlib/1.12/apache-madlib-'\
'1.12-src.tar.gz&action=download' -O madlib.tar.gz
tar -xvf madlib.tar.gz
cd ~/gpdb/build/apache-madlib-1.12-src
mkdir build
cd build
cmake ../
sudo make

cd ~/gpdb/build
for name in `awk '/^[[:space:]]*($|#)/{next} /mycluster/{print $2;}' /etc/hosts`; do
    if [ "${name}" == "mycluster-master" ]; then
        echo "Not Copying to Master"
        continue
    fi

    scp -r apache-madlib-1.12-src ${name}:/home/ubuntu/gpdb/build/
done

cd ~/gpdb/build/apache-madlib-1.12-src/build
echo "source /usr/local/gpdb/greenplum_path.sh" >> ~/.bashrc
./src/bin/madpack -p greenplum -s madlib install
