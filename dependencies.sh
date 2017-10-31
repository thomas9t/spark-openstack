#!/usr/bin/env bash

sudo apt-get -y update
sudo apt-get -y install libffi-dev libssl-dev python-dev
sudo apt-get -y install python-pip
sudo -H pip install --upgrade pip
sudo -H pip install os_client_config
sudo -H pip install shade
sudo -H pip install ansible==2.2
sudo -H pip install six
