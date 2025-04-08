#!/bin/bash

# Miscellaneous CIS Controls (banners, sudo logging, permissions)

echo "🧩 [Section 12] Miscellaneous - Level $CIS_LEVEL"

if [[ "$CIS_LEVEL" == "1" || "$CIS_LEVEL" == "all" ]]; then
    echo "Setting system banners (1.7.1.x)"
    echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue
    echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue.net
    chmod 644 /etc/issue /etc/issue.net
    chown root:root /etc/issue /etc/issue.net

    echo "Backing up /etc/motd"
    cp /etc/motd "$BACKUP_DIR/motd.bak" 2>/dev/null || true
    > /etc/motd

    echo "Ensuring permissions on /etc/passwd-, /etc/shadow-, /etc/group-, /etc/gshadow-"
    chmod 600 /etc/shadow- /etc/gshadow- 2>/dev/null || true
    chmod 644 /etc/passwd- /etc/group- 2>/dev/null || true
    chown root:root /etc/*- 2>/dev/null || true

    echo "Ensuring sudo logging is enabled (5.3.4)"
    cp /etc/sudoers "$BACKUP_DIR/sudoers.bak" 2>/dev/null || true
    grep -q '^Defaults.*logfile=' /etc/sudoers || echo 'Defaults logfile=\"*
