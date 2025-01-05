# LAMP Stack & phpMyAdmin Installer Script

## Pendahuluan
Script ini dirancang untuk mempermudah instalasi dan pengelolaan **LAMP Stack (Linux, Apache, MySQL, PHP)** dan **phpMyAdmin** pada sistem operasi **CentOS Stream 9**. Anda dapat menggunakan script ini untuk:

1. Memperbarui sistem.
2. Menginstal LAMP Stack dan phpMyAdmin.
3. Menghapus LAMP Stack dan phpMyAdmin.

## Fitur
1. **Memperbarui Sistem**  
   Menggunakan `dnf update` untuk memperbarui semua paket yang ada.
   
2. **Instalasi LAMP Stack & phpMyAdmin**  
   - PHP (versi 8.2 melalui Remi Repository).
   - Apache HTTP Server.
   - MySQL (versi 8.4 melalui MySQL Community Repository).
   - phpMyAdmin untuk pengelolaan database berbasis web.

3. **Penghapusan LAMP Stack & phpMyAdmin**  
   Menghapus semua layanan dan paket terkait, termasuk file konfigurasi dan data yang tersimpan.

## Persyaratan
- Sistem operasi **CentOS Stream 9**.
- Hak akses **root** atau menjalankan script dengan `sudo`.

## Cara Penggunaan

### 1. Unduh dan Jalankan Script
Salin isi script ini ke sebuah file bernama `lamp_installer.sh`. Kemudian berikan izin eksekusi:
```bash
chmod +x lamp_installer.sh
```
Jalankan script:
```bash
sudo ./lamp_installer.sh
```

### 2. Ikuti Menu Utama
Saat menjalankan script, Anda akan melihat menu berikut:

![alt text](https://github.com/RafiNashirudin/centos-lamp-installer/blob/main/Image/Menu.png?raw=true)

### 3. Pilih Opsi
- **Opsi 1:** Memperbarui sistem Anda ke versi terbaru.  
- **Opsi 2:** Menginstal LAMP Stack dan phpMyAdmin.  
- **Opsi 3:** Menghapus semua komponen LAMP Stack dan phpMyAdmin dari sistem.  
- **Opsi 4:** Keluar dari script.

---

## Akses phpMyAdmin
Setelah instalasi selesai, Anda dapat mengakses phpMyAdmin melalui browser di:
```
http://localhost/phpmyadmin
```

---

## Informasi Tambahan
- **Password Root MySQL**  
  Setelah instalasi MySQL, password root sementara akan ditampilkan di terminal.

- **Pengamanan MySQL**  
  Script akan secara otomatis menjalankan `mysql_secure_installation` untuk meningkatkan keamanan MySQL.

---

## Catatan Penting
- Pastikan Anda menjalankan script ini dengan hak akses **root**.
- Pastikan sistem Anda memiliki koneksi internet yang stabil untuk mengunduh paket.

---

## Kontributor
- **Author:** Rafi Nashirudin  
- **Homepage:** [rafinashirudin.my.id](https://www.rafinashirudin.my.id)  
- Dibuat dengan bantuan **ChatGPT**.

---

Semoga bermanfaat! 🚀
```
