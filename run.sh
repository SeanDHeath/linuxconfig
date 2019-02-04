#!/bin/bash
sudo apt install -y ansible
ansible-playbook -i "127.0.0.1," debian.yml
