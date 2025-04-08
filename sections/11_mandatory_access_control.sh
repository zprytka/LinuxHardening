#!/bin/bash

# 1.6.x - Mandatory Access Control (AppArmor)

echo "🛡️ [Section 11] Mandatory Access Control (AppArmor) - Level $CIS_LEVEL"

if [[ "$CIS_LEVEL" == "1" || "$CIS_LEVEL" == "all" ]]; then
    echo "Installing AppArmor and utils (1.6.1.1)"
    apt-get install -y apparmor apparmor-utils

    echo "Ensuring AppArmor is enabled (1.6.1.2)"
    systemctl enable apparmor
    systemctl start apparmor

    echo "Listing AppArmor enforced profiles (1.6.1.3)"
    aa-status | grep -q 'enforce' || echo \"⚠️ Warning: No profiles are in enforce mode. Review required.\"
fi
