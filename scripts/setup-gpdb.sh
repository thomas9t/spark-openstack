set -e
sudo apt-get -qq update
sudo apt-get -y install python-dev cmake git-core ccache libreadline-dev \
      bison flex zlib1g-dev openssl libssl-dev libpam-dev libcurl4-openssl-dev \
      libbz2-dev build-essential libapr1-dev libevent-dev libffi-dev libyaml-dev \
      libperl-dev

sudo apt-get install -y python-dev wget
wget https://bootstrap.pypa.io/get-pip.py
sudo -H python get-pip.py
rm get-pip.py

mkdir -p ~/gpdb/build
cd ~/gpdb/build
git clone https://github.com/greenplum-db/gp-xerces
cd ~/gpdb/build/gp-xerces
mkdir build
cd ~/gpdb/build/gp-xerces/build
sudo ../configure --prefix=/usr/local
sudo make
sudo make install

sudo -H pip install --upgrade lockfile paramiko setuptools epydoc
sudo -H pip install --upgrade psutil
sudo -H pip install --upgrade conan

cd ~/gpdb/build
git clone https://github.com/greenplum-db/gpdb
sudo apt-get install -y libxml2-dev vim iputils-ping
cd ~/gpdb/build/gpdb/depends
git checkout 5.1.0
sudo conan remote add conan-gpdb https://api.bintray.com/conan/greenplum-db/gpdb-oss
sudo conan install --build
cd ~/gpdb/build/gpdb
sudo ./configure --with-perl --with-python --with-libxml --enable-mapreduce --enable-orca --prefix=/usr/local/gpdb
sudo make
sudo make install
sudo apt-get install -y libboost-dev

sudo chown ubuntu:ubuntu -R ~/gpdb

sudo mkdir -p /data/master
sudo mkdir -p /data1/primary
sudo mkdir -p /data2/primary
export me=`whoami`
sudo chown -R $me:$me /data/master 
sudo chown -R $me:$me /data1
sudo chown -R $me:$me /data2
sudo ldconfig
