# 🚀 Cara Menjalankan SI-HARAT di Localhost

## Opsi 1: Python Server (Recommended)

### Langkah 1: Jalankan Server
```bash
# Di terminal, masuk ke direktori proyek
cd /Users/ahmadhakim/siharat

# Jalankan server Python
python3 start-server.py
```

### Langkah 2: Akses Dashboard
- Server akan otomatis membuka browser di: `http://localhost:8000/dashboard-bbm.html`
- Jika tidak otomatis, buka manual: `http://localhost:8000/dashboard-bbm.html`

---

## Opsi 2: Node.js Server

### Langkah 1: Jalankan Server
```bash
# Di terminal, masuk ke direktori proyek
cd /Users/ahmadhakim/siharat

# Jalankan server Node.js
node start-server.js
```

### Langkah 2: Akses Dashboard
- Server akan otomatis membuka browser di: `http://localhost:8000/dashboard-bbm.html`

---

## Opsi 3: Python Built-in Server

### Langkah 1: Jalankan Server
```bash
# Di terminal, masuk ke direktori proyek
cd /Users/ahmadhakim/siharat

# Python 3
python3 -m http.server 8000

# Atau Python 2
python -m SimpleHTTPServer 8000
```

### Langkah 2: Akses Dashboard
- Buka browser: `http://localhost:8000/dashboard-bbm.html`

---

## Opsi 4: PHP Server (jika PHP tersedia)

### Langkah 1: Jalankan Server
```bash
# Di terminal, masuk ke direktori proyek
cd /Users/ahmadhakim/siharat

# Jalankan server PHP
php -S localhost:8000
```

### Langkah 2: Akses Dashboard
- Buka browser: `http://localhost:8000/dashboard-bbm.html`

---

## 🌐 Dashboard yang Tersedia

Setelah server berjalan, Anda bisa mengakses:

1. **BBM Dashboard**: `http://localhost:8000/dashboard-bbm.html`
2. **Login**: `http://localhost:8000/login.html`
3. **Landing Page**: `http://localhost:8000/landing-siharat.html`
4. **Data Pegawai**: `http://localhost:8000/dashboard-data-pegawai-complete.html`

---

## 🔧 Troubleshooting

### Port Sudah Digunakan
```bash
# Coba port lain
python3 start-server.py --port 8001
# Atau
node start-server.js --port 8001
```

### Permission Denied
```bash
# Berikan permission execute
chmod +x start-server.py
chmod +x start-server.js
```

### Python Tidak Ditemukan
```bash
# Install Python (macOS)
brew install python3

# Atau gunakan Node.js
node start-server.js
```

### Node.js Tidak Ditemukan
```bash
# Install Node.js (macOS)
brew install node

# Atau gunakan Python
python3 start-server.py
```

---

## ✅ Verifikasi Setup

1. **Server berjalan**: Lihat pesan "Server berjalan di: http://localhost:8000"
2. **Browser terbuka**: Dashboard BBM otomatis terbuka
3. **Tidak ada error**: Console browser bersih
4. **Fungsi tambah kendaraan**: Form modal bisa dibuka

---

## 🎯 Quick Start

**Paling mudah:**
```bash
cd /Users/ahmadhakim/siharat
python3 start-server.py
```

**Lalu buka:** `http://localhost:8000/dashboard-bbm.html`

**Selesai!** 🎉
