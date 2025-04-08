#!/bin/bash

# 6.x - File permissions and ownership

echo "🔒 [Section 05] File Permissions - Level $CIS_LEVEL"

FILES=(
    "/etc/passwd"
    "/etc/shadow"
    "/etc/group"
    "/etc/gshadow"
)

if [[ "$CIS_LEVEL" == "1" || "$CIS_LEVEL" == "all" ]]; then
    for file in "${FILES[@]}"; do
        if [ -e "$file" ]; then
            echo "Backing up and setting permissions for $file"
            cp "$file" "$BACKUP_DIR/$(basename "$file").bak" 2>/dev/null || true
            case "$file" in
                "/etc/passwd") chmod 644 "$file" && chown root:root "$file";;
                "/etc/shadow") chmod 640 "$file" && chown root:shadow "$file";;
                "/etc/group")  chmod 644 "$file" && chown root:root "$file";;
                "/etc/gshadow") chmod 640 "$file" && chown root:shadow "$file";;
            esac
        fi
    done
fi
