-- Tabel untuk menyimpan data notulen rapat.
-- Skema ini sesuai dengan data yang dikirim dari form di `dashboard-notulen.html`.

CREATE TABLE IF NOT EXISTS notulen_rapat (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    judul_rapat TEXT NOT NULL,
    lokasi TEXT,
    tanggal_rapat DATE NOT NULL,
    waktu_mulai TIME,
    waktu_selesai TIME,
    pemimpin_rapat TEXT,
    peserta_rapat TEXT,
    agenda_pembahasan TEXT,
    action_items TEXT,
    keputusan TEXT,
    created_by UUID,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT fk_created_by
        FOREIGN KEY(created_by) 
        REFERENCES auth.users(id)
        ON DELETE SET NULL
);

-- Aktifkan Row Level Security (RLS)
ALTER TABLE notulen_rapat ENABLE ROW LEVEL SECURITY;

-- Kebijakan RLS:
-- 1. Pengguna yang terautentikasi dapat melihat semua notulen.
CREATE POLICY "Authenticated users can view all minutes"
ON notulen_rapat
FOR SELECT
USING (auth.role() = 'authenticated');

-- 2. Pengguna dapat membuat notulen baru.
CREATE POLICY "Users can create their own minutes"
ON notulen_rapat
FOR INSERT
WITH CHECK (auth.uid() = created_by);

-- 3. Pengguna hanya dapat mengedit notulen yang mereka buat.
CREATE POLICY "Users can update their own minutes"
ON notulen_rapat
FOR UPDATE
USING (auth.uid() = created_by);

-- 4. Pengguna hanya dapat menghapus notulen yang mereka buat.
CREATE POLICY "Users can delete their own minutes"
ON notulen_rapat
FOR DELETE
USING (auth.uid() = created_by);

-- Tambahkan komentar pada tabel dan kolom untuk kejelasan
COMMENT ON TABLE notulen_rapat IS 'Menyimpan semua data notulen rapat dari aplikasi SI-HARAT.';
COMMENT ON COLUMN notulen_rapat.judul_rapat IS 'Judul atau topik utama dari rapat.';
COMMENT ON COLUMN notulen_rapat.peserta_rapat IS 'Daftar peserta yang hadir, dipisahkan koma.';
COMMENT ON COLUMN notulen_rapat.action_items IS 'Daftar tugas atau item aksi yang dihasilkan dari rapat.';
COMMENT ON COLUMN notulen_rapat.created_by IS 'ID pengguna yang membuat notulen, terhubung ke tabel auth.users.';
