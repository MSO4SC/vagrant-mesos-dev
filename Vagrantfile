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

# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu1604"
  config.vm.synced_folder "../../../Projects", "/home/vagrant/Projects"
  
  config.vm.provision "shell", path: "scripts/basic-config.sh"
  
  #remove first localhost nodeX line in hosts file
  config.vm.provision "shell", inline: "echo -e \"$(sed '1d' /etc/hosts)\n\" > /etc/hosts"
  
  #set all hosts
  config.vm.provision "shell", path: "scripts/set-host.sh", args: "192.168.56.10 node1"
#  config.vm.provision "shell", path: "scripts/set_host.sh", args: "192.168.56.11 node2"
  
  ################################################################################################################
  ################################## zookeeper & mesos node (master & agent) #####################################
  ################################################################################################################
  config.vm.define "node1" do |node1|
    config.vm.network "private_network", ip: "192.168.56.10"
	config.vm.hostname = "node1"
	
	# install zookeeper
	config.vm.provision "shell", path: "scripts/zookeeper-install.sh", args: "node1 192.168.56.10 1 &> /dev/null"
	
	# install mesos and development dependencies
	config.vm.provision "shell", path: "../mesos-hpc-framework/scripts/build-dependencies.sh", args: "&> /dev/null"
	
	# install gui and mpi development tools
	config.vm.provision "shell", path: "scripts/gui.sh"
	config.vm.provision "shell", path: "scripts/dev-mpi.sh"
	config.vm.provision "file", source: "files/eclipse.desktop", destination: "/home/vagrant/Desktop/eclipse.desktop"
	config.vm.provision "file", source: "scripts/clean-eclipse.sh", destination: "/home/vagrant/Desktop/clean-eclipse.sh"
	config.vm.provision "shell", inline: "dos2unix /home/vagrant/Desktop/clean-eclipse.sh &> /dev/null"
	config.vm.provision "shell", inline: "chmod +x /home/vagrant/Desktop/clean-eclipse.sh"
	
	# install script to run mesos easily
	config.vm.provision "file", source: "scripts/zk_master_up.sh", destination: "up.sh"
	config.vm.provision "shell", inline: "dos2unix /home/vagrant/up.sh &> /dev/null"
	config.vm.provision "shell", inline: "chmod +x /home/vagrant/up.sh"
	
	
	config.vm.provider "virtualbox" do |vb|
		# Display the VirtualBox GUI when booting the machine
		vb.gui = true
		vb.cpus = 2    
		# Customize the amount of memory on the VM:
		vb.memory = "3072"
		vb.customize ["modifyvm", :id, "--vram", "12"]
		# Set the timesync threshold to 1 second, instead of the default 20 minutes.
        vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000]
	end
  end
  ################################################################################################################
  
  # config.vm.define "node2" do |node2|
    # config.vm.network "private_network", ip: "192.168.56.11"
	# config.vm.hostname = "node2"
	
	# config.vm.provision "file", source: "scripts/slave_up.sh", destination: "up.sh"
	# config.vm.provision "shell", path: "scripts/slave.sh", args: "192.168.56.11 node2 192.168.56.10"
  # end
  
  #HACK TO AVOID ttyname failed: Inappropiate ioctl for device
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
end
