#!/bin/bash

# 6.1.x - Cron and At daemon restrictions

echo "⏰ [Section 06] Cron and At - Level $CIS_LEVEL"

if [[ "$CIS_LEVEL" == "1" || "$CIS_LEVEL" == "all" ]]; then
    echo "Ensuring cron daemon is enabled and running (6.1.1)"
    apt-get install -y cron
    systemctl enable cron
    systemctl start cron

    echo "Backing up and creating cron.allow and at.allow files (6.1.2 - 6.1.6)"
    touch /etc/cron.allow /etc/at.allow
    cp /etc/cron.allow "$BACKUP_DIR/cron.allow.bak" 2>/dev/null || true
    cp /etc/at.allow "$BACKUP_DIR/at.allow.bak" 2>/dev/null || true

    chmod 600 /etc/cron.allow /etc/at.allow
    chown root:root /etc/cron.allow /etc/at.allow

    echo "Removing cron.deny and at.deny if they exist (6.1.5 - 6.1.6)"
    rm -f /etc/cron.deny /etc/at.deny
fi
