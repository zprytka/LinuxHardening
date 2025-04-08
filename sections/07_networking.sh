#!/bin/bash

# 3.x - Network parameters
CONF_FILE="/etc/sysctl.d/99-cis-networking.conf"

echo "🌐 [Section 07] Networking - Level $CIS_LEVEL"

if [[ "$CIS_LEVEL" == "1" || "$CIS_LEVEL" == "all" ]]; then
    cp "$CONF_FILE" "$BACKUP_DIR/99-cis-networking.conf.bak" 2>/dev/null || true

    echo "Disabling IPv6 (3.6.1)"
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >> "$CONF_FILE"
    echo "net.ipv6.conf.default.disable_ipv6 = 1" >> "$CONF_FILE"

    echo "Disabling source routed packets (3.2.1 - 3.2.2)"
    echo "net.ipv4.conf.all.accept_source_route = 0" >> "$CONF_FILE"
    echo "net.ipv4.conf.default.accept_source_route = 0" >> "$CONF_FILE"

    echo "Disabling ICMP redirects (3.3.1 - 3.3.2)"
    echo "net.ipv4.conf.all.accept_redirects = 0" >> "$CONF_FILE"
    echo "net.ipv4.conf.default.accept_redirects = 0" >> "$CONF_FILE"

    echo "Disabling secure ICMP redirects (3.3.3 - 3.3.4)"
    echo "net.ipv4.conf.all.secure_redirects = 0" >> "$CONF_FILE"
    echo "net.ipv4.conf.default.secure_redirects = 0" >> "$CONF_FILE"

    echo "Enabling reverse path filtering (3.2.3 - 3.2.4)"
    echo "net.ipv4.conf.all.rp_filter = 1" >> "$CONF_FILE"
    echo "net.ipv4.conf.default.rp_filter = 1" >> "$CONF_FILE"

    echo "Logging suspicious packets (3.4.1 - 3.4.2)"
    echo "net.ipv4.conf.all.log_martians = 1" >> "$CONF_FILE"
    echo "net.ipv4.conf.default.log_martians = 1" >> "$CONF_FILE"

    sysctl --system > /dev/null
fi
