#!/bin/bash

apt-get update &&
apt-get install sudo &&
useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

ln -sf /usr/share/zoneinfo/GMT /etc/localtime

apt-get -y install git
