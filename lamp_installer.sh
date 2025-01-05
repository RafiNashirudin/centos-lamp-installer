#!/bin/bash

# Banner Script
function banner {
    clear
    echo -e "\n\033[1;32m ██╗      █████╗ ███╗   ███╗██████╗     ███████╗████████╗ █████╗  ██████╗██╗  ██╗ \033[0m"
    echo -e "\033[1;32m ██║     ██╔══██╗████╗ ████║██╔══██╗    ██╔════╝╚══██╔══╝██╔══██╗██╔════╝██║ ██╔╝ \033[0m"
    echo -e "\033[1;32m ██║     ███████║██╔████╔██║██████╔╝    ███████╗   ██║   ███████║██║     █████╔╝  \033[0m"
    echo -e "\033[1;32m ██║     ██╔══██║██║╚██╔╝██║██╔═══╝     ╚════██║   ██║   ██╔══██║██║     ██╔═██╗  \033[0m"
    echo -e "\033[1;32m ███████╗██║  ██║██║ ╚═╝ ██║██║         ███████║   ██║   ██║  ██║╚██████╗██║  ██╗ \033[0m"
    echo -e "\033[1;32m ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝         ╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ v1.0 \033[0m"


    echo -e "\n\033[1;36m+ -- -- +=[ Author: Rafi Nashirudin | Homepage: rafinashirudin.my.id \033[1;m"
    echo -e "\033[1;36m+ -- -- +=[ Created with assistance from ChatGPT \033[1;m"
    echo -e "\033[1;36m+ -- -- +=[ Compatible : CentOS Stream 9 \033[1;m"

}

# Fungsi untuk menampilkan pesan
function info {
    echo -e "\033[1;34m$1\033[0m"
}

# Fungsi untuk meminta konfirmasi pengguna
function confirm {
    read -p "$1 (y/n): " choice
    case "$choice" in
        y|Y) return 0 ;;
        *) return 1 ;;
    esac
}

# Memastikan script dijalankan dengan hak akses root
if [ "$(id -u)" -ne 0 ]; then
    echo "Anda harus menjalankan script ini sebagai root. Jalankan dengan sudo!"
    exit 1
fi

# Menampilkan menu utama
function show_menu {
    banner
    info "\n\n==================================="
    info "   Pilih Opsi Instalasi    "
    info "==================================="
    info "1. Update Sistem"
    info "2. Instal LAMP Stack & phpMyAdmin"
    info "3. Hapus LAMP Stack & phpMyAdmin"
    info "4. Keluar"
    info "==================================="
    read -p "Pilih opsi (1/2/3/4): " choice
    case $choice in
        1) update_system ;;
        2) install_packages ;;
        3) remove_packages ;;
        4) exit 0 ;;
        *) info "Pilihan tidak valid. Silakan pilih lagi." ; show_menu ;;
    esac
}

# Fungsi untuk memperbarui sistem
function update_system {
    banner
    info "Memperbarui sistem Anda..."

    # Update paket
    dnf update -y --refresh
    info "Sistem telah diperbarui!"

    read -p "Tekan [Enter] untuk kembali ke menu utama..."
    show_menu
}

# Fungsi untuk menginstal LAMP Stack dan phpMyAdmin
function install_packages {
    banner
    info "Memulai instalasi LAMP Stack (Linux, Apache, MySQL, PHP) dan phpMyAdmin..."

    # Instalasi PHP
    dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm
    dnf module install -y php:remi-8.2
    php -v
    info "PHP telah terinstal."

    # Instalasi Apache HTTP Server
    dnf install -y httpd
    firewall-cmd --add-service=http --permanent
    firewall-cmd --add-service=https --permanent
    firewall-cmd --reload
    systemctl enable httpd
    systemctl start httpd
    systemctl status httpd --no-pager
    info "Apache HTTP Server telah terinstal."

    # Instalasi MySQL
    dnf install -y https://dev.mysql.com/get/mysql84-community-release-el9-1.noarch.rpm
    dnf install -y mysql-community-server
    systemctl enable mysqld
    systemctl start mysqld
    systemctl status mysqld --no-pager
    info "MySQL telah terinstal."

    # Menampilkan password root MySQL sementara
    info "Menampilkan password root MySQL sementara..."
    grep 'password' /var/log/mysqld.log

    # Pengamanan MySQL
    info "Mengamankan instalasi MySQL..."
    mysql_secure_installation <<EOF
n
Y
Y
Y
Y
EOF

    # Instalasi phpMyAdmin
    dnf config-manager --set-enabled crb
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-9.noarch.rpm
    dnf install -y phpmyadmin
    sed -i '/Require local/a\   Require all granted' /etc/httpd/conf.d/phpMyAdmin.conf
    systemctl restart httpd
    systemctl status httpd --no-pager

    info "Instalasi selesai! LAMP Stack dan phpMyAdmin telah terinstal dengan sukses."
    info "Silakan akses phpMyAdmin di http://localhost/phpmyadmin"
    read -p "Tekan [Enter] untuk kembali ke menu utama..."
    show_menu
}

# Fungsi untuk menghapus LAMP Stack dan phpMyAdmin
function remove_packages {
    banner
    info "Menghapus LAMP Stack dan phpMyAdmin..."

    # Menghentikan layanan
    systemctl stop httpd
    systemctl stop mysqld

    # Menghapus paket
    dnf remove -y php httpd mysql-community-server phpmyadmin

    # Hapus file konfigurasi dan data MySQL:
    rm -rf /var/lib/mysql
    rm -rf /etc/my.cnf /etc/my.cnf.d

    # Hapus log MySQL lama
    rm -f /var/log/mysqld.log

    # Hapus file konfigurasi phpMyAdmin:
    rm -rf /etc/phpMyAdmin
    rm -rf /usr/share/phpMyAdmin

    # Menghapus semua file cache
    dnf clean all

    # Menghapus dependensi yang tidak terpakai
    dnf autoremove -y

    info "Semua paket terkait telah dihapus!"
    read -p "Tekan [Enter] untuk kembali ke menu utama..."
    show_menu
}

# Menampilkan menu utama
show_menu