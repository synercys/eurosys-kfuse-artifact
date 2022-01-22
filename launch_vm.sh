#!/bin/bash
# trap "unset_cpufreq" EXIT
set_cpufreq() {
    sudo cpupower frequency-set -d 2099MHz -u 2100MHz
    sudo cpupower frequency-set -g performance
}

unset_cpufreq() {
    sudo cpupower frequency-set -d 800MHz -u 2100MHz
    sudo cpupower frequency-set -g ondemand
}

if [ $1 == "1" ]; then
    sudo ./scripts/qemu_kernel.sh vm/kfuse-retpoline-vm rootfs.ext4 /init.sh
elif [ $1 == "2" ]; then
    sudo ./scripts/qemu_kernel.sh vm/nokfuse-retpoline-vm rootfs.ext4 /init.sh
elif [ $1 == "3" ]; then
    sudo ./scripts/qemu_kernel.sh vm/kfuse-noretpoline-vm rootfs.ext4 /init.sh
elif [ $1 == "4" ]; then
    sudo ./scripts/qemu_kernel.sh vm/nokfuse-noretpoline-vm rootfs.ext4 /init.sh
elif [ $1 == "5" ]; then
    sudo ./scripts/qemu_kernel.sh vm/kfuse-retpoline-tail-vm rootfs.ext4 /init.sh
elif [ $1 == "6" ]; then
    sudo ./scripts/qemu_kernel.sh vm/nokfuse-retpoline-indirect-vm rootfs.ext4 /init.sh
fi
