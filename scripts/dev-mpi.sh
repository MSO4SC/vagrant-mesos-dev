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

# Install mpich
#apt-get install mpich -y -qq
# Install openmpi
apt-get install openmpi-bin -y -qq

## java
#apt-get install default-jre -y -qq

# eclipse PTP
wget -q http://ftp.fau.de/eclipse/technology/epp/downloads/release/neon/R/eclipse-parallel-neon-R-linux-gtk-x86_64.tar.gz
tar -zxf eclipse*.tar.gz
rm eclipse*.tar.gz
mv eclipse /opt
chown -R vagrant:vagrant /opt/eclipse
ln -s /opt/eclipse/eclipse /usr/bin/
mv /home/vagrant/eclipse.desktop /home/vagrant/Desktop/

#cpplint and clang-format
sudo apt-get install -y clang-format
sudo wget -q https://raw.githubusercontent.com/google/styleguide/gh-pages/cpplint/cpplint.py -P /usr/bin/
sudo chmod a+x /usr/bin/cpplint.py
