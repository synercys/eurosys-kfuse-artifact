#!/bin/bash

apt update
apt install iptables iproute2 perl git qemu-system-x86

git clone --depth=1 https://github.com/nferraz/st.git
cd st
perl Makefile.PL
make
make install
cd ..
