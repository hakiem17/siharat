-- Simple version for testing - Create log_pengisian_token table
CREATE TABLE IF NOT EXISTS log_pengisian_token (
    id BIGSERIAL PRIMARY KEY,
    petugas_id UUID,
    nomor_meter VARCHAR(255) NOT NULL,
    tanggal_pengisian DATE NOT NULL,
    waktu_pengisian TIME WITH TIME ZONE DEFAULT CURRENT_TIME,
    nominal_pembelian NUMERIC NOT NULL,
    jumlah_kwh NUMERIC NOT NULL,
    nomor_token VARCHAR(255) UNIQUE NOT NULL,
    saldo_kwh_sebelum NUMERIC,
    saldo_kwh_sesudah NUMERIC,
    foto_bukti TEXT,
    keterangan TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Disable RLS for testing (NOT recommended for production)
ALTER TABLE log_pengisian_token DISABLE ROW LEVEL SECURITY;

-- Add indexes for performance
CREATE INDEX IF NOT EXISTS idx_log_pengisian_token_petugas_id ON log_pengisian_token (petugas_id);
CREATE INDEX IF NOT EXISTS idx_log_pengisian_token_nomor_meter ON log_pengisian_token (nomor_meter);
CREATE INDEX IF NOT EXISTS idx_log_pengisian_token_tanggal_pengisian ON log_pengisian_token (tanggal_pengisian);

-- Sample Data
INSERT INTO log_pengisian_token (petugas_id, nomor_meter, tanggal_pengisian, nominal_pembelian, jumlah_kwh, nomor_token, saldo_kwh_sebelum, saldo_kwh_sesudah, keterangan)
VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', '12345678901', '2025-09-20', 50000, 35.7, '1234-5678-9012-3456', 100, 135.7, 'Pembelian rutin bulanan'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', '12345678902', '2025-09-21', 20000, 14.2, '9876-5432-1098-7654', 50, 64.2, 'Pembelian darurat')
ON CONFLICT (nomor_token) DO NOTHING;
