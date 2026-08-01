# LAMP Stack Installer v1.2

Installer sederhana untuk **CentOS Stream 9** yang membantu menginstal, memperbarui, dan menghapus **Apache, PHP, MySQL Community Server,** serta **phpMyAdmin** melalui menu interaktif.

---

## Fitur

- Update sistem menggunakan DNF
- Install Apache HTTP Server
- Install PHP 8.3 (Remi Repository)
- Install MySQL Community Server 8.4
- Install phpMyAdmin
- Konfigurasi Firewall HTTP & HTTPS
- Mengaktifkan service Apache dan MySQL secara otomatis
- Uninstall seluruh LAMP Stack beserta data MySQL

---

## Persyaratan

- CentOS Stream 9
- Akses **root** atau **sudo**
- Koneksi internet

---

## Instalasi

Berikan izin eksekusi:

```bash
chmod +x lamp_installer.sh
```

Jalankan installer:

```bash
sudo ./lamp_installer.sh
```

---

## Menu

```
1. Update Sistem
2. Install LAMP Stack & phpMyAdmin
3. Hapus LAMP Stack & phpMyAdmin
4. Keluar
```

---

## Setelah Instalasi

Akses phpMyAdmin melalui browser:

```
http://IP_SERVER/phpmyadmin
```

Password sementara MySQL akan ditampilkan di terminal.

Amankan instalasi MySQL dengan menjalankan:

```bash
mysql_secure_installation
```

---

## Yang Diinstal

- Apache HTTP Server
- PHP 8.3
- MySQL Community Server 8.4
- phpMyAdmin
- EPEL Repository
- Remi Repository

---

## Changelog

### v1.2

- Menggunakan PHP 8.3
- Menggunakan MySQL Community Server 8.4
- Pengecekan paket sebelum instalasi
- Konfigurasi Firewalld otomatis
- Mengaktifkan service otomatis
- Perbaikan proses uninstall
- Perbaikan tampilan menu
- Optimasi penanganan error

---

## Author

**Rafi Nashirudin**

🌐 https://rafinashirudin.my.id
