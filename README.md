
# Ubuntu 20.04 Hardening Scripts

Este repositorio contiene un conjunto modular de scripts Bash diseñados para aplicar las recomendaciones del benchmark de seguridad **CIS (Center for Internet Security)** para sistemas **Ubuntu 20.04 LTS**.

## 🛡️ Estructura del Proyecto

```
cis_hardening/
├── apply-all.sh                  
└── sections/
    ├── 01_filesystems.sh
    ├── 02_sysctl.sh
    ├── 03_ssh.sh
    ├── 03_ssh_openscap_compliant.sh  
    ├── 04_logging.sh
    ├── 05_permissions.sh
    ├── 06_cron_at.sh
    ├── 07_networking.sh
    ├── 08_services.sh
    ├── 09_firewall_ufw_nftables.sh
    ├── 10_users_pam_env.sh
    ├── 11_mandatory_access_control.sh
    └── 12_miscellaneous.sh
```

## 🚀 Uso

### 1. Clonar el repositorio

```bash
git clone https://github.com/tuusuario/cis_hardening.git
cd cis_hardening
```

### 2. Dar permisos de ejecución

```bash
chmod +x apply-all.sh sections/*.sh
```

### 3. Ejecutar

```bash
sudo ./apply-all.sh 1     # Nivel 1 (por defecto)
sudo ./apply-all.sh 2     # Nivel 2
sudo ./apply-all.sh all   # Ejecutar todo sin filtrar por nivel
```

> 📝 Se crea automáticamente un respaldo de archivos en una carpeta `backup_YYYY-MM-DD_HH:MM:SS`.


## ⚠️ Requisitos

- Probado en Ubuntu 20.04 LTS
- Bash
- Permisos de superusuario (sudo)
- OpenSCAP (opcional para validación)

## 📁 Backups

Todos los archivos modificados se respaldan en una carpeta con timestamp para permitir reversión manual.


---

Inspirado por el benchmark oficial CIS y adaptado para entornos prácticos de hardening y auditoría.
