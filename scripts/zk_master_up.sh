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

sudo /opt/zookeeper-*/bin/zkServer.sh start
tmux new-session -d -s mesosphere -n master 'sudo mesos-master --work_dir=/var/lib/mesos --zk=zk://node1:2181/mesos --quorum=1'
tmux new-window -n agent 'sudo mesos-agent --work_dir=/var/lib/mesos --master=zk://node1:2181/mesos --executor_environment_variables="/home/vagrant/Projects/mso4sc/mesos-hpc-framework/slurm_executor/etc/config.json"'
tmux new-window -n framework
tmux send-keys -t 'mesosphere:2' 'cd /home/vagrant/Projects/mso4sc/mesos-hpc-framework/hpc_framework/Debug' Enter
tmux send-keys -t 'mesosphere:2' 'DEFAULT_PRINCIPAL= ./hpc-framework --master=192.168.56.10:5050'
tmux attach-session 