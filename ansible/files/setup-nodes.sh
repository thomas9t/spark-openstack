#!/bin/bash

############################
# install java related stuff
############################

sudo apt-get -y update
echo debconf shared/accepted-oracle-license-v1-1 select true | \
  sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | \
  sudo debconf-set-selections
printf '\n' | sudo apt-add-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get -y install oracle-java8-installer
sudo apt-get -y install sbt

if [ -f ~/SETUP_COMPLETE ]; then
    exit 0
fi

git config --global user.email "nunya@business.com"
git config --global user.name "R Daneel Olivaw"

#################
# Install OpenMPI
#################

sudo apt-get -y install openmpi-bin openmpi-doc libopenmpi-dev
echo "export PATH=/usr/lib64/openmpi/bin:$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/lib64/openmpi/lib" >> ~/.bashrc
source ~/.bashrc

#############
# Install NFS
#############

sudo apt-get -y install nfs-kernel-server
sudo apt-get -y install nfs-common

###########
# Install R
###########

sudo echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | sudo tee -a /etc/apt/sources.list
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -
sudo apt-get -y update
sudo apt-get -y install r-base r-base-dev
sudo apt-get -y install libopenblas-dev

##############################
# Install Python related stuff
##############################

mkdir Software
cd Software
sudo apt-get -y install python-dev
sudo apt-get -y install python-wheel
wget https://bootstrap.pypa.io/get-pip.py
sudo -H python get-pip.py
sudo -H pip install --upgrade pip
sudo -H pip install --upgrade numpy 
sudo -H pip install --upgrade scipy 
sudo -H pip install --upgrade pandas 
sudo -H pip install --upgrade matplotlib 
sudo -H pip install --upgrade ipython
sudo -H pip install --upgrade psycopg2
sudo -H pip install --upgrade gslab_tools

##############################
# Install Bazel and TensorFlow
##############################

#echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
#curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -
#sudo apt-get update && sudo apt-get -y install bazel

#git clone https://github.com/tensorflow/tensorflow 
#cd tensorflow
#git checkout r1.4
#printf '\n\nn\nn\nn\nn\nn\nn\nn\nn\n' | ./configure
#bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package
#bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
#sudo -H pip install /tmp/tensorflow_pkg/`ls /tmp/tensorflow_pkg`

#######################
# Install Scala and SBT
#######################

echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
sudo apt-get update
sudo apt-get install sbt
sudo apt-get install bc

############
# Get Eigen3
############

cd ~/Software
wget http://bitbucket.org/eigen/eigen/get/3.3.3.tar.gz
tar -xvf 3.3.3.tar.gz
cd eigen-eigen-67e894c6cd8f
echo "export EIGEN3_INCLUDE_DIR=`pwd`" >> ~/.bashrc

##################
# Get Commons Math
##################

sudo apt-get -y install maven

cd ~/Software
wget http://mirror.stjschools.org/public/apache/commons/math/source/commons-math3-3.6.1-src.tar.gz
tar -xvf commons-math3-3.6.1-src.tar.gz
cd commons-math3-3.6.1-src
mvn clean install
cd target
echo "export COMMONS_MATH_JAR=`pwd`/commons-math3-3.6.1.jar" >> ~/.bashrc

source ~/.bashrc

########################################################
# A bit of hackyness is needed to get R to use this BLAS
########################################################

cd /usr/lib/libblas
sudo mv libblas.so _libblas.so
sudo mv libblas.so.3 _libblas.so.3

sudo ln -s /usr/lib/openblas/lib/libopenblas.so libblas.so
sudo ln -s /usr/lib/openblas/lib/libopenblas.so libblas.so.3

############################
# Install Greenplum Database
############################

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
sudo -H pip install conan==0.30.3

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

echo "export BENCHMARK_PROJECT_ROOT=/home/ubuntu/benchmark" >> ~/.bashrc
echo "COMPLETE" > ~/SETUP_COMPLETE
