#!/bin/bash

# ==========================================
# KONFIGURASI & VARIABEL UTAMA
# ==========================================
VERSION="1.1"
AUTHOR="Rafi Nashirudin"
HOMEPAGE="rafinashirudin.my.id"
OS_COMPAT="CentOS Stream 9"

# Versioning & Repository URLs
PHP_VERSION="8.3"
MYSQL_REPO_URL="https://dev.mysql.com/get/mysql84-community-release-el9-1.noarch.rpm"
EPEL_REPO_URL="https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm"
EPEL_NEXT_URL="https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-9.noarch.rpm"

# Kode Warna Terminal
RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
NC="\033[0m"

# ==========================================
# FUNGSI UTILITAS & TAMPILAN
# ==========================================
function banner {
    clear
    echo -e "${GREEN}"
    echo ' ██╗      █████╗ ███╗   ███╗██████╗     ███████╗████████╗ █████╗  ██████╗██╗  ██╗ '
    echo ' ██║     ██╔══██╗████╗ ████║██╔══██╗    ██╔════╝╚══██╔══╝██╔══██╗██╔════╝██║ ██╔╝ '
    echo ' ██║     ███████║██╔████╔██║██████╔╝    ███████╗   ██║   ███████║██║     █████╔╝  '
    echo ' ██║     ██╔══██║██║╚██╔╝██║██╔═══╝     ╚════██║   ██║   ██╔══██║██║     ██╔═██╗  '
    echo ' ███████╗██║  ██║██║ ╚═╝ ██║██║         ███████╗   ██║   ██║  ██║╚██████╗██║  ██╗ '
    echo " ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝         ╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ v${VERSION}${NC}\n"
    
    echo -e "${CYAN}+ -- -- +=[ Author: ${AUTHOR} | Homepage: ${HOMEPAGE}${NC}"
    echo -e "${CYAN}+ -- -- +=[ Compatible : ${OS_COMPAT}${NC}\n"
}

function info {
    echo -e "${BLUE}[INFO] $1${NC}"
}

function check_status {
    if [ $? -ne 0 ]; then
        echo -e "${RED}[ERROR] $1${NC}"
        read -p "Tekan [Enter] untuk kembali ke menu..."
        return 1
    fi
    return 0
}

function confirm {
    read -p "$1 (y/n): " choice
    case "$choice" in
        y|Y) return 0 ;;
        *) return 1 ;;
    esac
}

# Pengecekan Hak Akses Root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}[ERROR] Anda harus menjalankan script ini sebagai root. Jalankan dengan sudo!${NC}"
    exit 1
fi

# ==========================================
# FUNGSI UTAMA
# ==========================================
function update_system {
    banner
    info "Memperbarui sistem Anda..."
    dnf update -y --refresh
    check_status "Gagal memperbarui sistem." || return
    
    info "Sistem telah diperbarui!"
    read -p "Tekan [Enter] untuk kembali ke menu utama..."
}

function install_packages {
    banner
    info "Memulai instalasi LAMP Stack & phpMyAdmin..."

    # Instalasi PHP
    info "Menginstal PHP ${PHP_VERSION}..."
    dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm > /dev/null 2>&1
    dnf module reset php -y > /dev/null 2>&1
    dnf module install -y php:remi-${PHP_VERSION} > /dev/null 2>&1
    check_status "Gagal menginstal PHP." || return

    # Instalasi Apache
    info "Menginstal Apache HTTP Server..."
    dnf install -y httpd > /dev/null 2>&1
    check_status "Gagal menginstal Apache." || return
    
    firewall-cmd --add-service=http --permanent > /dev/null 2>&1
    firewall-cmd --add-service=https --permanent > /dev/null 2>&1
    firewall-cmd --reload > /dev/null 2>&1
    
    systemctl enable --now httpd > /dev/null 2>&1
    
    # Instalasi MySQL
    info "Menginstal MySQL Server..."
    dnf install -y ${MYSQL_REPO_URL} > /dev/null 2>&1
    dnf install -y mysql-community-server > /dev/null 2>&1
    check_status "Gagal menginstal MySQL." || return
    
    systemctl enable --now mysqld > /dev/null 2>&1

    # Instalasi phpMyAdmin
    info "Menginstal phpMyAdmin..."
    dnf config-manager --set-enabled crb > /dev/null 2>&1
    dnf install -y ${EPEL_REPO_URL} ${EPEL_NEXT_URL} > /dev/null 2>&1
    dnf install -y phpmyadmin > /dev/null 2>&1
    check_status "Gagal menginstal phpMyAdmin." || return

    # Konfigurasi Akses phpMyAdmin
    sed -i '/Require local/a\   Require all granted' /etc/httpd/conf.d/phpMyAdmin.conf
    systemctl restart httpd > /dev/null 2>&1

    # Mengambil Password Sementara MySQL
    TEMP_PASS=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
    
    echo -e "\n========================================================"
    echo -e "${GREEN}Instalasi Selesai!${NC}"
    echo -e "Akses phpMyAdmin di : ${CYAN}http://<IP_SERVER>/phpmyadmin${NC}"
    echo -e "Password root sementara MySQL Anda : ${RED}${TEMP_PASS}${NC}"
    echo -e "Silakan jalankan perintah ${CYAN}mysql_secure_installation${NC} secara manual setelah ini."
    echo -e "========================================================\n"
    
    read -p "Tekan [Enter] untuk kembali ke menu utama..."
}

function remove_packages {
    banner
    if confirm "Apakah Anda YAKIN ingin menghapus LAMP Stack & DATABASE MySQL?"; then
        info "Menghentikan layanan..."
        systemctl stop httpd mysqld > /dev/null 2>&1
        
        info "Menghapus paket DNF..."
        dnf remove -y php\* httpd\* mysql-community-server phpmyadmin > /dev/null 2>&1

        info "Menghapus file konfigurasi dan direktori data..."
        rm -rf /var/lib/mysql
        rm -rf /etc/my.cnf /etc/my.cnf.d
        rm -f /var/log/mysqld.log
        rm -rf /etc/phpMyAdmin /usr/share/phpMyAdmin

        dnf clean all > /dev/null 2>&1
        dnf autoremove -y > /dev/null 2>&1

        info "Semua paket dan data terkait telah berhasil dihapus!"
    else
        info "Proses penghapusan dibatalkan."
    fi
    read -p "Tekan [Enter] untuk kembali ke menu utama..."
}

# ==========================================
# MAIN LOOP MENU
# ==========================================
while true; do
    banner
    echo -e "${BLUE}===================================${NC}"
    echo -e "   Pilih Opsi Instalasi    "
    echo -e "${BLUE}===================================${NC}"
    echo "1. Update Sistem"
    echo "2. Instal LAMP Stack & phpMyAdmin"
    echo "3. Hapus LAMP Stack & phpMyAdmin"
    echo "4. Keluar"
    echo -e "${BLUE}===================================${NC}"
    read -p "Pilih opsi (1/2/3/4): " choice
    
    case $choice in
        1) update_system ;;
        2) install_packages ;;
        3) remove_packages ;;
        4) info "Keluar dari program. Terima kasih!"; exit 0 ;;
        *) info "Pilihan tidak valid."; sleep 1 ;;
    esac
done

