#!/bin/bash
set -e
trap 'echo "Error occured at line $LINENO"' ERR
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y

echo "System updated and cleaned!"
