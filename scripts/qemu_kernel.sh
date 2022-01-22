#!/bin/bash -e

KERNEL=$1
ROOTFS=$2
INIT=${3:-/init.sh}
TAP=tap_kfuse


TAP_IP=172.16.2.1
VM_IP=172.16.2.2

setup_tap() {
    local TAP=$1
    IP=$2
    ip tuntap add $TAP mode tap
    ip addr add $IP/24 dev $TAP
    ip link set $TAP up
    sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
    iptables -t nat -A POSTROUTING -o eno2 -j MASQUERADE
    iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    iptables -A FORWARD -i $TAP -o eno2 -j ACCEPT
}

if ip link | grep $TAP; then
    echo "Reuse $TAP"
else
    echo "Create $TAP"
    setup_tap $TAP $TAP_IP
fi

qemu-system-x86_64  -smp 2 -m 8G -enable-kvm -cpu host \
    -kernel $KERNEL  -drive format=raw,file=$ROOTFS,if=virtio \
    -nographic -no-reboot \
    -netdev tap,id=$TAP,ifname=$TAP,script=no,downscript=no \
    -device virtio-net-pci,netdev=$TAP,mac=AA:FC:00:00:00:01 \
    -append "console=ttyS0 ip=$VM_IP::$TAP_IP:255.255.255.0:vm:eth0:off nokaslr random.trust_cpu=on init=$INIT root=/dev/vda rw"
