-- Insert sample employees for BBM approval system
-- This ensures there are valid employee IDs for the approved_by field

INSERT INTO employees (nip, name, position, rank_class, division, employee_type, phone, email, is_active) VALUES
('196512031990031001', 'Dr. Ahmad Hakim, S.Kom., M.T.', 'Kepala Dinas', 'Pembina Utama Muda / IV/c', 'Sekretariat', 'PNS', '081234567890', 'ahmad.hakim@siharat.com', true),
('197803151998032002', 'Siti Nurhaliza, S.E.', 'Sekretaris', 'Pembina / IV/a', 'Sekretariat', 'PNS', '081234567891', 'siti.nurhaliza@siharat.com', true),
('PPPK001', 'Budi Santoso, S.Kom.', 'Analis Sistem Informasi', 'Ahli Pertama', 'Bidang Informatika', 'PPPK', '081234567892', 'budi.santoso@siharat.com', true),
('198204201999032003', 'Dewi Sartika, S.Sos.', 'Kepala Bidang Komunikasi', 'Pembina / IV/a', 'Bidang Komunikasi', 'PNS', '081234567893', 'dewi.sartika@siharat.com', true),
('PPPK002', 'Rizki Pratama, S.Stat.', 'Statistisi Muda', 'Ahli Pertama', 'Bidang Statistik', 'PPPK', '081234567894', 'rizki.pratama@siharat.com', true)
ON CONFLICT (nip) DO NOTHING;

-- Verify employees were inserted
SELECT id, name, nip FROM employees WHERE is_active = true LIMIT 5;
