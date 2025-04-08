#!/bin/bash

# 1.2.x - Disable unused services

SERVICES=(
    avahi-daemon
    cups
    isc-dhcp-server
    slapd
    nfs-kernel-server
    bind9
    vsftpd
    apache2
    dovecot
    samba
    squid
    snmpd
    telnetd
    tftp
    xinetd
)

echo "📦 [Section 08] Unused Services - Level $CIS_LEVEL"

if [[ "$CIS_LEVEL" == "1" || "$CIS_LEVEL" == "all" ]]; then
    for svc in "${SERVICES[@]}"; do
        if systemctl is-enabled "$svc" &>/dev/null; then
            echo "Disabling and stopping $svc"
            systemctl stop "$svc"
            systemctl disable "$svc"
        fi
        if dpkg -l | grep -qw "$svc"; then
            echo "Optionally removing package: $svc"
            # Uncomment the line below to remove the package entirely
            # apt-get purge -y "$svc"
        fi
    done
fi
