#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install libffi-dev libssl-dev python-dev
sudo apt-get install python-pip
sudo pip install --upgrade pip
sudo pip install os_client_config
sudo pip install shade
sudo pip install ansible==2.2
sudo pip install six
