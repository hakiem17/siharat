-- Script untuk memperbaiki constraint tabel notulen_rapat
-- Jalankan di Supabase SQL Editor

-- 1. Cek constraint yang ada
SELECT 
    column_name, 
    is_nullable, 
    data_type,
    column_default
FROM information_schema.columns 
WHERE table_name = 'notulen_rapat' 
ORDER BY ordinal_position;

-- 2. Buat kolom nullable jika diperlukan (opsional)
-- ALTER TABLE notulen_rapat ALTER COLUMN waktu_mulai DROP NOT NULL;
-- ALTER TABLE notulen_rapat ALTER COLUMN waktu_selesai DROP NOT NULL;

-- 3. Atau tambahkan default values
ALTER TABLE notulen_rapat ALTER COLUMN waktu_mulai SET DEFAULT '09:00';
ALTER TABLE notulen_rapat ALTER COLUMN waktu_selesai SET DEFAULT '10:00';

-- 4. Test insert minimal
INSERT INTO notulen_rapat (
    judul_rapat, 
    lokasi, 
    tanggal_rapat
) VALUES (
    'Test Minimal Insert', 
    'Test Lokasi', 
    CURRENT_DATE
);

-- 5. Test insert dengan semua field
INSERT INTO notulen_rapat (
    judul_rapat, 
    lokasi, 
    tanggal_rapat,
    waktu_mulai,
    waktu_selesai,
    pemimpin_rapat,
    peserta_rapat,
    agenda_pembahasan,
    action_items,
    keputusan_diambil,
    gambar_notulen
) VALUES (
    'Test Full Insert', 
    'Ruang Meeting A', 
    CURRENT_DATE,
    '09:00',
    '10:00',
    'Admin Test',
    'Peserta 1, Peserta 2',
    '1. Pembahasan agenda\n2. Review progress',
    '1. Tugas 1 - Admin\n2. Tugas 2 - User',
    '1. Approved budget\n2. New timeline',
    '[
        {
            "name": "meeting-photo.jpg",
            "path": "notulen-images/meeting-photo.jpg",
            "url": "https://msqqqkmcvnltvfcgtrhy.supabase.co/storage/v1/object/public/notulen-images/meeting-photo.jpg",
            "size": 2048,
            "type": "image/jpeg"
        }
    ]'::jsonb
);

-- 6. Verifikasi data
SELECT 
    id, 
    judul_rapat, 
    lokasi,
    tanggal_rapat,
    waktu_mulai,
    waktu_selesai,
    pemimpin_rapat,
    CASE 
        WHEN gambar_notulen IS NOT NULL AND jsonb_array_length(gambar_notulen) > 0 
        THEN jsonb_array_length(gambar_notulen) 
        ELSE 0 
    END as jumlah_gambar
FROM notulen_rapat 
ORDER BY created_at DESC 
LIMIT 3;
