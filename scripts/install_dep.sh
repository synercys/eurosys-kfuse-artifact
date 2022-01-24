#!/bin/bash

apt update
apt install --no-install-recommends iptables iproute2 perl git qemu-system-x86 make

apt-get update
apt-get install build-essential autoconf automake libpcre3-dev libevent-dev pkg-config zlib1g-dev libssl-dev libtool
git clone https://github.com/RedisLabs/memtier_benchmark.git
cd memtier_benchmark
autoreconf -ivf
./configure
make
make install

git clone --depth=1 https://github.com/nferraz/st.git
cd st
perl Makefile.PL
make
make install
cd ..
