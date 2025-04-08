#!/bin/bash

# 5.2.x - Secure SSH configuration
CONF_FILE="/etc/ssh/sshd_config"
CONF_DIR="/etc/ssh/sshd_config.d"
CUSTOM_CONF="$CONF_DIR/00-complianceascode-hardening.conf"
DEFAULTS_CONF="$CONF_DIR/01-complianceascode-reinforce-os-defaults.conf"
BACKUP_NAME="sshd_config.bak"

echo "🔐 [Section 03] SSH - Level $CIS_LEVEL"

if [[ "$CIS_LEVEL" == "1" || "$CIS_LEVEL" == "all" ]]; then
    # Backup original sshd_config
    cp "$CONF_FILE" "$BACKUP_DIR/$BACKUP_NAME" 2>/dev/null || true

    echo "Disabling SSH root login (5.2.2)"
    sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' "$CONF_FILE"
    grep -q "^PermitRootLogin" "$CONF_FILE" || echo "PermitRootLogin no" >> "$CONF_FILE"

    echo "Setting ClientAlive settings via separate config file (per OpenSCAP)"
    mkdir -p "$CONF_DIR"
    touch "$CUSTOM_CONF"
    chmod 0600 "$CUSTOM_CONF"

    # Remove from sshd_config and other config.d files
    sed -i '/^\s*ClientAliveInterval\s\+/Id' "$CONF_FILE"
    sed -i '/^\s*ClientAliveCountMax\s\+/Id' "$CONF_FILE"
    sed -i '/^\s*ClientAliveInterval\s\+/Id' "$CONF_DIR"/*.conf 2>/dev/null || true
    sed -i '/^\s*ClientAliveCountMax\s\+/Id' "$CONF_DIR"/*.conf 2>/dev/null || true

    echo "ClientAliveInterval 300" > "$CUSTOM_CONF"
    echo "ClientAliveCountMax 0" >> "$CUSTOM_CONF"
    sed -i -e '$a\' "$CUSTOM_CONF"

    echo "Disabling empty passwords per OpenSCAP standard (5.2.10)"
    if dpkg-query --show --showformat='${db:Status-Status}\n' 'linux-base' 2>/dev/null | grep -q ^installed; then
        mkdir -p "$CONF_DIR"
        touch "$DEFAULTS_CONF"
        chmod 0600 "$DEFAULTS_CONF"

        LC_ALL=C sed -i "/^\s*PermitEmptyPasswords\s\+/Id" "$CONF_FILE"
        LC_ALL=C sed -i "/^\s*PermitEmptyPasswords\s\+/Id" "$CONF_DIR"/*.conf 2>/dev/null || true

        if [ -e "$DEFAULTS_CONF" ]; then
            LC_ALL=C sed -i "/^\s*PermitEmptyPasswords\s\+/Id" "$DEFAULTS_CONF"
        else
            touch "$DEFAULTS_CONF"
        fi

        sed -i -e '$a\' "$DEFAULTS_CONF"

        cp "$DEFAULTS_CONF" "$DEFAULTS_CONF.bak"
        printf '%s\n' "PermitEmptyPasswords no" > "$DEFAULTS_CONF"
        cat "$DEFAULTS_CONF.bak" >> "$DEFAULTS_CONF"
        rm "$DEFAULTS_CONF.bak"
    else
        >&2 echo 'Remediation is not applicable, nothing was done'
    fi

    echo "Validating sshd config before restart..."
    if sshd -t; then
        echo "✅ sshd config OK, restarting sshd"
        systemctl restart sshd
    else
        echo "❌ sshd config has syntax errors, NOT restarting!"
    fi
fi

