-- ========================================
-- BBM Management Tables for SI-HARAT
-- ========================================

-- Create vehicles table
CREATE TABLE IF NOT EXISTS vehicles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nomor_polisi VARCHAR(20) UNIQUE NOT NULL,
    merk VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    jenis_kendaraan VARCHAR(50) NOT NULL,
    tahun_pembuatan INTEGER NOT NULL,
    is_active BOOLEAN DEFAULT true,
    keterangan TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create log_pengisian_bbm table
CREATE TABLE IF NOT EXISTS log_pengisian_bbm (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    tanggal_pengisian DATE NOT NULL,
    waktu_pengisian TIME NOT NULL,
    employee_id UUID REFERENCES employees(id),
    vehicle_id UUID REFERENCES vehicles(id),
    kilometer_kendaraan INTEGER,
    jenis_bbm VARCHAR(50) NOT NULL,
    jumlah_liter DECIMAL(10,2) NOT NULL,
    harga_per_liter DECIMAL(10,2) NOT NULL,
    total_biaya DECIMAL(12,2) NOT NULL,
    foto_kuitansi TEXT,
    keterangan TEXT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    approved_by UUID REFERENCES employees(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_vehicles_nomor_polisi ON vehicles(nomor_polisi);
CREATE INDEX IF NOT EXISTS idx_vehicles_active ON vehicles(is_active);
CREATE INDEX IF NOT EXISTS idx_log_pengisian_bbm_tanggal ON log_pengisian_bbm(tanggal_pengisian);
CREATE INDEX IF NOT EXISTS idx_log_pengisian_bbm_employee ON log_pengisian_bbm(employee_id);
CREATE INDEX IF NOT EXISTS idx_log_pengisian_bbm_vehicle ON log_pengisian_bbm(vehicle_id);
CREATE INDEX IF NOT EXISTS idx_log_pengisian_bbm_status ON log_pengisian_bbm(status);

-- Enable RLS
ALTER TABLE vehicles ENABLE ROW LEVEL SECURITY;
ALTER TABLE log_pengisian_bbm ENABLE ROW LEVEL SECURITY;

-- RLS Policies for vehicles
CREATE POLICY "Admin can manage vehicles" ON vehicles
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE users.id = auth.uid() 
      AND users.role = 'admin'
    )
  );

-- RLS Policies for log_pengisian_bbm
CREATE POLICY "Admin can manage fuel logs" ON log_pengisian_bbm
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE users.id = auth.uid() 
      AND users.role = 'admin'
    )
  );

-- Insert sample vehicles
INSERT INTO vehicles (nomor_polisi, merk, model, jenis_kendaraan, tahun_pembuatan, is_active, keterangan) VALUES
('B 1234 ABC', 'Toyota', 'Avanza', 'MPV', 2020, true, 'Mobil dinas utama'),
('B 5678 DEF', 'Honda', 'Jazz', 'Hatchback', 2019, true, 'Mobil operasional'),
('B 9012 GHI', 'Suzuki', 'Ertiga', 'MPV', 2021, true, 'Mobil dinas tambahan'),
('B 3456 JKL', 'Toyota', 'Innova', 'MPV', 2018, false, 'Mobil tidak aktif'),
('B 7890 MNO', 'Daihatsu', 'Terios', 'SUV', 2020, true, 'Mobil lapangan')
ON CONFLICT (nomor_polisi) DO NOTHING;

-- Insert sample fuel logs
INSERT INTO log_pengisian_bbm (
    tanggal_pengisian, 
    waktu_pengisian, 
    employee_id, 
    vehicle_id, 
    kilometer_kendaraan, 
    jenis_bbm, 
    jumlah_liter, 
    harga_per_liter, 
    total_biaya, 
    keterangan, 
    status
) VALUES
(
    '2024-01-15', 
    '08:30:00', 
    (SELECT id FROM employees WHERE nip = '196512031990031001' LIMIT 1),
    (SELECT id FROM vehicles WHERE nomor_polisi = 'B 1234 ABC' LIMIT 1),
    50000,
    'Pertalite',
    25.5,
    10000.00,
    255000.00,
    'Pengisian rutin mingguan',
    'approved'
),
(
    '2024-01-16', 
    '14:15:00', 
    (SELECT id FROM employees WHERE nip = '197803151998032002' LIMIT 1),
    (SELECT id FROM vehicles WHERE nomor_polisi = 'B 5678 DEF' LIMIT 1),
    35000,
    'Pertalite',
    20.0,
    10000.00,
    200000.00,
    'Pengisian untuk perjalanan dinas',
    'pending'
),
(
    '2024-01-17', 
    '10:45:00', 
    (SELECT id FROM employees WHERE nip = 'PPPK001' LIMIT 1),
    (SELECT id FROM vehicles WHERE nomor_polisi = 'B 9012 GHI' LIMIT 1),
    25000,
    'Pertalite',
    30.0,
    10000.00,
    300000.00,
    'Pengisian penuh tangki',
    'approved'
)
ON CONFLICT DO NOTHING;

-- Create trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Add triggers for updated_at
CREATE TRIGGER update_vehicles_updated_at 
    BEFORE UPDATE ON vehicles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_log_pengisian_bbm_updated_at 
    BEFORE UPDATE ON log_pengisian_bbm
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Create view for fuel consumption summary
CREATE OR REPLACE VIEW fuel_consumption_summary AS
SELECT 
    v.nomor_polisi,
    v.merk,
    v.model,
    COUNT(l.id) as total_pengisian,
    SUM(l.jumlah_liter) as total_liter,
    SUM(l.total_biaya) as total_biaya,
    AVG(l.jumlah_liter) as rata_rata_liter,
    MAX(l.tanggal_pengisian) as pengisian_terakhir
FROM vehicles v
LEFT JOIN log_pengisian_bbm l ON v.id = l.vehicle_id AND l.status = 'approved'
WHERE v.is_active = true
GROUP BY v.id, v.nomor_polisi, v.merk, v.model;

-- Success message
DO $$
BEGIN
    RAISE NOTICE '✅ BBM Management tables created successfully!';
    RAISE NOTICE '🚗 Vehicles table: Created with sample data';
    RAISE NOTICE '⛽ Log pengisian BBM table: Created with sample data';
    RAISE NOTICE '📊 Indexes and RLS policies: Configured';
    RAISE NOTICE '🎯 Ready for BBM dashboard!';
END $$;
