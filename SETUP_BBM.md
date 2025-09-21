# Setup BBM Dashboard - SI-HARAT

## Masalah yang Diperbaiki
✅ **JavaScript errors sudah diperbaiki:**
- Duplicate 'supabase' variable declaration
- Missing 'saveVehicle' function reference  
- Chart.js source map 404 error

## File yang Diperlukan
1. ✅ `database/bbm_tables.sql` - Script database untuk tabel kendaraan dan log BBM
2. ✅ `dashboard-bbm.html` - Dashboard BBM dengan fungsi tambah kendaraan
3. ✅ `assets/js/supabase-client.js` - Client Supabase

## Cara Setup Database

### Langkah 1: Buat Tabel Database
1. Buka Supabase Dashboard
2. Pergi ke SQL Editor
3. Copy dan paste isi file `database/bbm_tables.sql`
4. Jalankan script SQL

### Langkah 2: Test Dashboard
1. Buka `dashboard-bbm.html` di browser
2. Klik tombol "Tambah Kendaraan"
3. Isi form kendaraan:
   - Nomor Polisi: B 1234 ABC
   - Merk: Toyota
   - Model: Avanza
   - Jenis: MPV
   - Tahun: 2020
4. Klik "Simpan Kendaraan"

## Fitur Tambah Kendaraan
- ✅ Form lengkap dengan validasi
- ✅ Cek duplikasi nomor polisi
- ✅ Auto-uppercase nomor polisi
- ✅ Validasi tahun (1990-2025)
- ✅ Status aktif/nonaktif
- ✅ Keterangan tambahan

## Troubleshooting
Jika ada error:
1. Pastikan tabel `vehicles` dan `log_pengisian_bbm` sudah dibuat
2. Cek console browser untuk error JavaScript
3. Pastikan koneksi Supabase berfungsi
4. Verifikasi RLS policies di Supabase

## Status
🎯 **Dashboard BBM siap digunakan dengan fungsi tambah kendaraan yang berfungsi penuh!**
