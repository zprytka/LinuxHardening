#!/bin/bash

# 5.4.x - User accounts and PAM settings

echo "👤 [Section 10] Users, PAM and Environment - Level $CIS_LEVEL"

if [[ "$CIS_LEVEL" == "1" || "$CIS_LEVEL" == "all" ]]; then
    echo "Setting password expiration defaults (5.4.1.1)"
    cp /etc/login.defs "$BACKUP_DIR/login.defs.bak" 2>/dev/null || true
    sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   7/' /etc/login.defs
    sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE   7/' /etc/login.defs

    echo "Setting default umask in /etc/profile (5.4.4)"
    cp /etc/profile "$BACKUP_DIR/profile.bak" 2>/dev/null || true
    sed -i 's/^umask.*/umask 027/' /etc/profile
    grep -q '^umask' /etc/profile || echo 'umask 027' >> /etc/profile

    echo "Ensuring PAM limits are set (5.5.1.1)"
    cp /etc/security/limits.conf "$BACKUP_DIR/limits.conf.bak" 2>/dev/null || true
    echo '* hard core 0' >> /etc/security/limits.conf

    echo "Locking inactive accounts after 30 days (5.4.1.4)"
    useradd -D -f 30
    cp /etc/default/useradd "$BACKUP_DIR/useradd.bak" 2>/dev/null || true
    sed -i 's/^INACTIVE=.*/INACTIVE=30/' /etc/default/useradd
fi
