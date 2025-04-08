#!/bin/bash

# 1.1.x - Disable unused filesystem modules
MODS=(cramfs freevxfs jffs2 hfs hfsplus squashfs udf)

CONF_FILE="/etc/modprobe.d/cis.conf"

echo "📁 [Section 01] Filesystems - Level $CIS_LEVEL"

if [[ "$CIS_LEVEL" == "1" || "$CIS_LEVEL" == "all" ]]; then
    cp "$CONF_FILE" "$BACKUP_DIR/cis.conf.bak" 2>/dev/null || true

    for mod in "${MODS[@]}"; do
        echo "Disabling filesystem module: $mod"
        echo "install $mod /bin/true" >> "$CONF_FILE"
    done
fi
