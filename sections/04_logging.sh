#!/bin/bash

# 4.x - Logging and auditing

echo "📜 [Section 04] Logging & Auditing - Level $CIS_LEVEL"

if [[ "$CIS_LEVEL" == "1" || "$CIS_LEVEL" == "all" ]]; then
    echo "Installing and enabling rsyslog (4.2.1 - 4.2.2)"
    apt-get install -y rsyslog
    systemctl enable rsyslog
    systemctl start rsyslog

    echo "Installing and enabling auditd (4.1.1 - 4.1.2)"
    apt-get install -y auditd audispd-plugins
    systemctl enable auditd
    systemctl start auditd

    echo "Ensuring audit is enabled at boot (4.1.3)"
    grep -q "audit=1" /etc/default/grub || sed -i 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="audit=1 /' /etc/default/grub
    update-grub

    echo "Ensuring logrotate runs periodically (4.3)"
    apt-get install -y logrotate
    if [ ! -f /etc/cron.daily/logrotate ]; then
        echo -e "#!/bin/sh\n/usr/sbin/logrotate /etc/logrotate.conf" > /etc/cron.daily/logrotate
        chmod +x /etc/cron.daily/logrotate
        echo "✔️ logrotate daily cron job created."
    else
        echo "ℹ️ logrotate daily job already exists."
    fi

    echo "auditd and rsyslog configured. Reboot may be required to enable audit=1."
fi
