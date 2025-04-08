#!/bin/bash

# 1.3.x - Kernel parameters
CONF_FILE="/etc/sysctl.d/99-cis-hardening.conf"

echo "🧠 [Section 02] Kernel sysctl - Level $CIS_LEVEL"

if [[ "$CIS_LEVEL" == "1" || "$CIS_LEVEL" == "all" ]]; then
    cp "$CONF_FILE" "$BACKUP_DIR/99-cis-hardening.conf.bak" 2>/dev/null || true

    echo "Enabling ASLR"
    sysctl -w kernel.randomize_va_space=2
    echo "kernel.randomize_va_space = 2" >> "$CONF_FILE"

    echo "Disabling core dumps"
    echo "fs.suid_dumpable = 0" >> "$CONF_FILE"
    sysctl -w fs.suid_dumpable=0

    sysctl --system > /dev/null
fi
