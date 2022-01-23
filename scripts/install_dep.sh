#!/bin/bash

sudo apt update
sudo apt install iptables iproute2 perl git qemu-system-x86

git clone --depth=1 git@github.com:nferraz/st.git
cd st
perl Makefile.PL
make
sudo make install
cd ..
