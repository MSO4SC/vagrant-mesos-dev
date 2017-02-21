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