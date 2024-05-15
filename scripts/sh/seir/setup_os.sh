#!/bin/bash

apt-get update &&
apt-get install sudo &&
useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

ln -sf /usr/share/zoneinfo/GMT /etc/localtime

apt-get -y install git
apt-get -y install jq

apt-get -y install python3.11
apt-get -y install python3-pip
apt-get -y install python-is-python3
