#!/bin/bash

ARCH=$(uname -a)
PCPU=$(grep "cpu cores" /proc/cpuinfo | uniq | wc -l)
VCPU=$(grep -c processor /proc/cpuinfo)
RAM_TOTAL=$(free -h | grep Mem | awk '{print $2}')
RAM_USED=$(free -h | grep Mem | awk '{print $3}')
RAM_PERC=$(free -k | grep Mem | awk '{printf "%.2f%%", $3/$2 * 100}')
DISK_TOTAL=$(df -h --total | grep total | awk '{print $2}')
DISK_USED=$(df -h --total | grep total | awk '{print $3}')
DISK_PERC=$(df -h --total | grep total | awk '{printf "%.2f%%", $3/$2 * 100}')
CPU_LOAD=$(top -bn1 | grep load | awk '{printf "%.1f%%", (substr($11, 1, length($11)-1))/1 * 100}')
LAST_BOOT=$(who -b | awk '{print $3, $4}')
LVM=$(if [ $(lsblk | grep lvm | wc -l) -eq 0 ]; then echo no; else echo yes; fi)
TCP=$(grep TCP /proc/net/sockstat | awk '{print $3}')
USER_LOG=$(w | grep users | awk '{print $5}')
IP_ADDR=$(hostname -I)
MAC_ADDR=$(ip a | grep link/ether | awk '{print $2}')
SUDO_LOG=$(grep -a COMMAND /var/log/sudo/sudo.log | wc -l)

wall "
        -----------------------------------------------------
        Architecture    : $ARCH
        CPU physical    : $PCPU
        vCPU            : $VCPU
        Memory Usage    : $RAM_USED/$RAM_TOTAL ($RAM_PERC)
        Disk Usage      : $DISK_USED/$DISK_TOTAL ($DISK_PERC)
        CPU load        : $CPU_LOAD
        Last boot       : $LAST_BOOT
        LVM use         : $LVM
        Connexions TCP  : $TCP ESTABLISHED
        User log        : $USER_LOG
        Network         : $IP_ADDR ($MAC_ADDR)
        Sudo            : $SUDO_LOG cmd
        -----------------------------------------------------"
