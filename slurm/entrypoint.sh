#!/bin/bash
service munge start
# 判断是否带--with-ldap参数
if [ "$2" = "--with-ldap" ]; then
    chmod 600 /etc/sssd/sssd.conf
    service sssd start
fi
if [ "$1" = "slurmd" ]; then
    # 启动slurmd
    slurmd -Dvvv 
elif [ "$1" = "slurmctld" ]; then
    if [ ! -f /root/not-first-run ]; then
        echo "Waiting for slurmdbd to start..."
        sleep 15
        echo "Creating slurm cluster..."
        name="$(cat /etc/slurm/slurm.conf | grep ClusterName | awk -F '[=\r]' '{print $2}')"
        sacctmgr -i add cluster "$name"
        touch /root/not-first-run
    fi
    echo "Waiting for slurmdbd to start..."
    sleep 15
    slurmctld -Dvvv
elif [ "$1" = "slurmdbd" ]; then
    if [ ! -f /root/not-first-run ]; then
        chmod 600 /etc/slurm/slurmdbd.conf
        chown slurm:slurm /etc/slurm/slurmdbd.conf
        mkdir -p /var/spool/slurmctld
        chown slurm:slurm /var/spool/slurmctld
        touch /root/not-first-run
    fi
    slurmdbd -Dvvv
elif [ "$1" = "slurmctld-dbd" ]; then
    if [ ! -f /root/not-first-run ]; then
        chmod 600 /etc/slurm/slurmdbd.conf
        chown slurm:slurm /etc/slurm/slurmdbd.conf
        mkdir -p /var/spool/slurmctld
        chown slurm:slurm /var/spool/slurmctld
        service slurmdbd start
        echo "Waiting for slurmdbd to start..."
        sleep 15
        echo "Creating slurm cluster..."
        name="$(cat /etc/slurm/slurm.conf | grep ClusterName | awk -F '[=\r]' '{print $2}')"
        sacctmgr -i add cluster "$name"
        touch /root/not-first-run
    fi
    service slurmdbd restart
    echo "Waiting for slurmdbd to start..."
    sleep 15
    slurmctld -Dvvv
else
    echo "Unknow command $0 $@"
    echo "Usage: $0 {slurmd|slurmctld|slurmdbd|slurmctld-dbd}"
fi