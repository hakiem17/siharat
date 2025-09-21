-- Script untuk menambahkan dukungan gambar ke tabel notulen_rapat
-- Jalankan di Supabase SQL Editor

-- 1. Tambahkan kolom untuk menyimpan path gambar
ALTER TABLE notulen_rapat 
ADD COLUMN IF NOT EXISTS gambar_notulen JSONB DEFAULT '[]'::jsonb;

-- 2. Tambahkan komentar untuk kolom
COMMENT ON COLUMN notulen_rapat.gambar_notulen IS 'Array JSON berisi informasi gambar yang diupload (path, nama file, dll)';

-- 3. Buat storage bucket untuk gambar notulen
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'notulen-images',
    'notulen-images', 
    true,
    5242880, -- 5MB limit
    ARRAY['image/jpeg', 'image/png', 'image/gif', 'image/webp']
) ON CONFLICT (id) DO NOTHING;

-- 4. Buat policy untuk bucket notulen-images
-- Policy untuk membaca gambar (public access)
CREATE POLICY "Public read access for notulen images"
ON storage.objects FOR SELECT
USING (bucket_id = 'notulen-images');

-- Policy untuk upload gambar (authenticated users)
CREATE POLICY "Authenticated users can upload notulen images"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'notulen-images' 
    AND auth.role() = 'authenticated'
);

-- Policy untuk update gambar (authenticated users)
CREATE POLICY "Authenticated users can update notulen images"
ON storage.objects FOR UPDATE
USING (
    bucket_id = 'notulen-images' 
    AND auth.role() = 'authenticated'
);

-- Policy untuk delete gambar (authenticated users)
CREATE POLICY "Authenticated users can delete notulen images"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'notulen-images' 
    AND auth.role() = 'authenticated'
);

-- 5. Verifikasi setup
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'notulen_rapat' 
AND column_name = 'gambar_notulen';

-- 6. Test insert dengan gambar (dengan semua field required)
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
    'Test Notulen dengan Gambar', 
    'Test Lokasi', 
    CURRENT_DATE,
    '09:00',
    '10:00',
    'Test Pemimpin',
    'Test Peserta',
    'Test Agenda',
    'Test Action Items',
    'Test Keputusan',
    '[
        {
            "name": "test-image.jpg",
            "path": "notulen-images/test-image.jpg",
            "url": "https://msqqqkmcvnltvfcgtrhy.supabase.co/storage/v1/object/public/notulen-images/test-image.jpg",
            "size": 1024,
            "type": "image/jpeg"
        }
    ]'::jsonb
);

-- 7. Verifikasi data
SELECT 
    id, 
    judul_rapat, 
    gambar_notulen 
FROM notulen_rapat 
WHERE judul_rapat = 'Test Notulen dengan Gambar';
