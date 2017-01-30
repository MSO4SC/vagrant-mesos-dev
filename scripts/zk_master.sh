#!/bin/bash

# Copyright 2017 MSO4SC - javier.carnero@atos.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

sed -i 's/us/es/g' /etc/default/keyboard 

#remove first localhost nodeX line in hosts file
echo -e "$(sed '1d' /etc/hosts)\n" > /etc/hosts

# apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF &> /dev/null
# DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
# CODENAME=$(lsb_release -cs)
# echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | tee /etc/apt/sources.list.d/mesosphere.list

apt-get update -y -qq

## java
apt-get install default-jdk -y -qq
echo 'JAVA_HOME="/usr/lib/jvm/default-java"' >> /etc/environment
source /etc/environment

## zookeeper
wget -q http://apache.mirror1.spango.com/zookeeper/stable/zookeeper-3.4.9.tar.gz
mv zookeeper-* /opt
cd /opt
tar -xvzf zookeeper-*
rm zookeeper-*.tar.gz
cd /opt/zookeeper-*/conf
cp zoo_sample.cfg zoo.cfg
sed -i 's/dataDir=[a-z|\/]*/dataDir=\/var\/zookeeper/' zoo.cfg
# common config for all zk nodes
echo "server.1=node1:2888:3888" >> zoo.cfg
# current zk node id
mkdir /var/zookeeper
echo $3 > /var/zookeeper/myid
cd

## mesos
apt-get install autoconf libtool -y -qq
apt-get install python-dev libcurl4-nss-dev libsasl2-dev libsasl2-modules maven libapr1-dev libsvn-dev -y -qq
wget -q http://www.apache.org/dist/mesos/1.1.0/mesos-1.1.0.tar.gz
mv mesos-* /opt
cd /opt
tar -xvzf mesos-*
rm mesos-*.tar.gz
cd mesos-*
#./bootstrap # Only required if building from git repository
mkdir build
cd build
../configure  &> /dev/null
make &> /dev/null
make check  &> /dev/null
make install &> /dev/null
ldconfig

## mesos development
apt-get install libboost-dev libboost-thread-dev libssh-dev protobuf-compiler -y -qq
/usr/lib/x86_64-linux-gnu/libboost_system.so.1.58.0 /usr/lib/x86_64-linux-gnu/libboost_system.so
/usr/lib/x86_64-linux-gnu/libboost_filesystem.so.1.58.0 /usr/lib/x86_64-linux-gnu/libboost_filesystem.so

# ## scripts previously uploaded
dos2unix /home/vagrant/up.sh &> /dev/null
chmod +x /home/vagrant/up.sh

# ## golang
# apt-get install golang git libdevmapper-event1.02.1 -y -qq
# echo "export GOPATH=/home/vagrant/go" > /etc/profile.d/golang.sh
# source /etc/profile.d/golang.sh

# ## docker
# apt-get install apt-transport-https ca-certificates -y -qq
# apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D &> /dev/null
# echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | tee /etc/apt/sources.list.d/docker.list
# apt-get update -y -qq
# apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual -y -qq
# apt-get install docker-engine -y -qq
# echo 'docker,mesos' | tee /etc/mesos-slave/containerizers