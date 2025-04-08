#!/bin/bash

# 3.5.x - Firewall configuration (ufw and nftables)

echo "🔥 [Section 09] Firewall - Level $CIS_LEVEL"

if [[ "$CIS_LEVEL" == "1" || "$CIS_LEVEL" == "all" ]]; then
    echo "Installing and enabling ufw"
    apt-get install -y ufw

    echo "Allowing SSH (port 22) to avoid lockout"
    ufw allow 22/tcp comment 'Allow SSH access'

    echo "Setting default policies"
    ufw default deny incoming
    ufw default allow outgoing

    echo "Enabling ufw (safe to proceed)"
    ufw --force enable
    systemctl enable ufw
fi

if [[ "$CIS_LEVEL" == "2" || "$CIS_LEVEL" == "all" ]]; then
    echo "Installing and configuring nftables"
    apt-get install -y nftables
    systemctl enable nftables
    systemctl start nftables

    echo "Writing safe nftables rules (includes SSH)"
    echo 'table inet filter {
  chain input {
    type filter hook input priority 0;
    policy drop;
    iif lo accept
    ct state established,related accept
    tcp dport { 22 } accept
  }
  chain forward {
    type filter hook forward priority 0; policy drop;
  }
  chain output {
    type filter hook output priority 0; policy accept;
  }
}' > /etc/nftables.conf

    nft -f /etc/nftables.conf
fi
