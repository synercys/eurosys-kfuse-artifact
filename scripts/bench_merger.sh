#!/bin/bash
trap "unset_cpufreq; pkill -9 qemu; cleanup_ssh" EXIT
LINUX="kuarantine-linux"
VMIP=172.16.2.2
ITERATION=10
KERNEL_MERGER_RETPOLINE="vm/kfuse-retpoline-vm"
KERNEL_NOMERGER_RETPOLINE="vm/nokfuse-retpoline-vm"
KERNEL_MERGER_NORETPOLINE="vm/kfuse-noretpoline-vm"
KERNEL_NOMERGER_NORETPOLINE="vm/nokfuse-noretpoline-vm"

KERNELS=( \
    $KERNEL_MERGER_RETPOLINE \
    $KERNEL_NOMERGER_RETPOLINE \
    $KERNEL_MERGER_NORETPOLINE \
    $KERNEL_NOMERGER_NORETPOLINE \
)

largest() {
    n=$1
    shift
    array=$@
    echo ${array[@]} | tr ' ' '\n' | sort -nr | head -n $n
}

smallest() {
    n=$1
    shift
    array=$@
    echo ${array[@]} | tr ' ' '\n' | sort -n | head -n $n
}

set_cpufreq() {
    sudo cpupower frequency-set -d 2099MHz -u 2100MHz
    sudo cpupower frequency-set -g performance
}

unset_cpufreq() {
    sudo cpupower frequency-set -d 800MHz -u 2100MHz
    sudo cpupower frequency-set -g ondemand
}

cleanup_ssh() {
    ps aux | grep "ssh root@$VMIP" | awk '{print $2}' | xargs kill -9
}

start_vm() {
    sudo pkill qemu
    sleep 2;
    cp fs/e1fs.ext4 e1fs.ext4
    sudo ./scripts/qemu_kernel.sh $k e1fs.ext4 /lib/systemd/systemd > vm_log &
    sleep 4;
    scp -C guest/bpf_microbench.out root@$VMIP:~
}

run_redis_client() {
    result_array=()
    for i in $(seq $ITERATION); do
        ssh root@$VMIP "redis-cli flushall"
        sleep 2
        #result_array+=(`taskset -c 15 redis-benchmark -h $VMIP -t get --csv -n 5000000 \
                    #| awk -F',' '{print $2}' | tr -d '"'`)
        result_array+=(`memtier_benchmark -P redis -t 10 ratio=1:10 \
            --hide-histogram -s $VMIP | awk '/Totals/{print $2}'`)
        echo ${result_array[@]}
    done
}

run_nginx_client() {
    result_array=()
    for i in $(seq $ITERATION);
    do
        result_array+=(`wrk -t 10 -d 30s http://$VMIP:80/index.nginx-debian.html \
            | awk '/Requests\/sec:/{print $2}'`)
        echo ${result_array[@]}
    done
}

prepare_redis() {
    ssh root@$VMIP "rm /var/log/redis/redis-server.log"
    ssh root@$VMIP "sysctl vm.overcommit_memory=1"
    ssh root@$VMIP "echo never > /sys/kernel/mm/transparent_hugepage/enabled"
    ssh root@$VMIP "sed -i 's/^bind.*/bind 0.0.0.0 ::0/' /etc/redis/redis.conf"
    ssh root@$VMIP "sed -i 's/^daemonize.*/daemonize no/' /etc/redis/redis.conf"
}
calculate_stats() {
    average=$(echo ${result_array[@]} | tr ' ' '\n' | st --mean)
    if [[ ${#result_array[@]} == "1" ]]; then
        return;
    fi
    stderr=$(echo ${result_array[@]} | tr ' ' '\n' | st --stderr)
}

make -C guest bpf_microbench.out
set_cpufreq;
for cmd in $@; do
for k in ${KERNELS[@]}; do
    echo "Benchmarking $k"
    if [[ "$cmd" == "redis-real" ]]; then
        # overall
        if echo $k | grep -q nokfuse; then
            start_vm
            prepare_redis
            scp -C guest/redis_overall.bpf root@$VMIP:~
            ssh root@$VMIP -f "/root/bpf_microbench.out 0 1 redis-overall"
            sleep 5
            if [[ `ssh root@$VMIP 'head -n 1 /proc/$(pgrep redis)/seccomp_filters'` != "1" ]]; then
                echo assertion error
                exit 1
            fi
            run_redis_client
            calculate_stats
            echo $cmd-optimized 1 $(basename $k) $average $stderr | tee -a bpf_microbench.result
        fi
        # systemd
        start_vm
        prepare_redis
        ssh root@$VMIP "sed -i 's/^daemonize.*/daemonize yes/' /etc/redis/redis.conf"
        ssh root@$VMIP "systemctl restart redis-server"
        sleep 5
        run_redis_client
        calculate_stats
        echo $cmd 19 $(basename $k) $average $stderr | tee -a bpf_microbench.result
        # baseline
        start_vm
        prepare_redis
        ssh root@$VMIP -f "/root/bpf_microbench.out 0 1 redis"
        sleep 5
        if [[ `ssh root@$VMIP 'head -n 1 /proc/$(pgrep redis)/seccomp_filters'` != "0" ]]; then
            echo assertion error
            exit 1
        fi
        run_redis_client
        calculate_stats
        echo $cmd 0 $(basename $k) $average $stderr | tee -a bpf_microbench.result
    else
        echo wromg input

    fi
    sudo pkill firecracker
    sleep 1
done
done
