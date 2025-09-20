-- ========================================
-- SI-HARAT Database Setup Script
-- ========================================

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ========================================
-- 1. USERS TABLE
-- ========================================
CREATE TABLE users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'user' CHECK (role IN ('admin', 'hr_manager', 'user')),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- 2. EMPLOYEES TABLE (Data Pegawai)
-- ========================================
CREATE TABLE employees (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nip VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    position VARCHAR(255) NOT NULL,
    rank_class VARCHAR(100),
    division VARCHAR(255) NOT NULL,
    employee_type VARCHAR(20) CHECK (employee_type IN ('PNS', 'PPPK')),
    phone VARCHAR(20),
    email VARCHAR(255),
    address TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- 3. MEETINGS TABLE (Data Rapat)
-- ========================================
CREATE TABLE meetings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    meeting_date TIMESTAMP WITH TIME ZONE NOT NULL,
    location VARCHAR(255),
    organizer_id UUID REFERENCES users(id),
    status VARCHAR(20) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'ongoing', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- 4. MEETING ATTENDANCE TABLE (Absensi Rapat)
-- ========================================
CREATE TABLE meeting_attendance (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    meeting_id UUID REFERENCES meetings(id) ON DELETE CASCADE,
    employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    attendance_status VARCHAR(20) DEFAULT 'present' CHECK (attendance_status IN ('present', 'absent', 'late')),
    check_in_time TIMESTAMP WITH TIME ZONE,
    check_out_time TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(meeting_id, employee_id)
);

-- ========================================
-- 5. MEETING MINUTES TABLE (Notulen Rapat)
-- ========================================
CREATE TABLE meeting_minutes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    meeting_id UUID REFERENCES meetings(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    decisions TEXT,
    action_items TEXT,
    next_meeting_date TIMESTAMP WITH TIME ZONE,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- 6. FUEL MANAGEMENT TABLE (Manajemen BBM)
-- ========================================
CREATE TABLE fuel_management (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    vehicle_name VARCHAR(255) NOT NULL,
    fuel_type VARCHAR(50) NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    unit VARCHAR(10) DEFAULT 'L',
    price_per_unit DECIMAL(10,2),
    total_cost DECIMAL(12,2),
    refuel_date TIMESTAMP WITH TIME ZONE NOT NULL,
    odometer_reading INTEGER,
    driver_name VARCHAR(255),
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- 7. ELECTRICITY MANAGEMENT TABLE (Manajemen Listrik)
-- ========================================
CREATE TABLE electricity_management (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    building_name VARCHAR(255) NOT NULL,
    meter_number VARCHAR(100),
    previous_reading DECIMAL(10,2),
    current_reading DECIMAL(10,2),
    usage_amount DECIMAL(10,2) GENERATED ALWAYS AS (current_reading - previous_reading) STORED,
    rate_per_kwh DECIMAL(10,2),
    total_cost DECIMAL(12,2),
    reading_date TIMESTAMP WITH TIME ZONE NOT NULL,
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- 8. REPORTS TABLE (Laporan)
-- ========================================
CREATE TABLE reports (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    report_type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    file_path VARCHAR(500),
    generated_by UUID REFERENCES users(id),
    generated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    period_start DATE,
    period_end DATE
);

-- ========================================
-- INDEXES FOR PERFORMANCE
-- ========================================

-- Employees indexes
CREATE INDEX idx_employees_nip ON employees(nip);
CREATE INDEX idx_employees_division ON employees(division);
CREATE INDEX idx_employees_type ON employees(employee_type);
CREATE INDEX idx_employees_active ON employees(is_active);

-- Meetings indexes
CREATE INDEX idx_meetings_date ON meetings(meeting_date);
CREATE INDEX idx_meetings_organizer ON meetings(organizer_id);
CREATE INDEX idx_meetings_status ON meetings(status);

-- Attendance indexes
CREATE INDEX idx_attendance_meeting ON meeting_attendance(meeting_id);
CREATE INDEX idx_attendance_employee ON meeting_attendance(employee_id);
CREATE INDEX idx_attendance_status ON meeting_attendance(attendance_status);

-- Fuel management indexes
CREATE INDEX idx_fuel_date ON fuel_management(refuel_date);
CREATE INDEX idx_fuel_vehicle ON fuel_management(vehicle_name);

-- Electricity management indexes
CREATE INDEX idx_electricity_date ON electricity_management(reading_date);
CREATE INDEX idx_electricity_building ON electricity_management(building_name);

-- Reports indexes
CREATE INDEX idx_reports_type ON reports(report_type);
CREATE INDEX idx_reports_generated_by ON reports(generated_by);
CREATE INDEX idx_reports_period ON reports(period_start, period_end);

-- ========================================
-- SAMPLE DATA
-- ========================================

-- Insert sample users
INSERT INTO users (email, username, password_hash, full_name, role) VALUES
('admin@siharat.com', 'admin', '$2a$10$hash...', 'Administrator SI-HARAT', 'admin'),
('hr@siharat.com', 'hr_manager', '$2a$10$hash...', 'Manager HR', 'hr_manager'),
('user@siharat.com', 'user', '$2a$10$hash...', 'User Biasa', 'user');

-- Insert sample employees
INSERT INTO employees (nip, name, position, rank_class, division, employee_type, phone, email) VALUES
('196512031990031001', 'Dr. Ahmad Hakim, S.Kom., M.T.', 'Kepala Dinas', 'Pembina Utama Muda / IV/c', 'Sekretariat', 'PNS', '081234567890', 'ahmad.hakim@siharat.com'),
('197803151998032002', 'Siti Nurhaliza, S.E.', 'Sekretaris', 'Pembina / IV/a', 'Sekretariat', 'PNS', '081234567891', 'siti.nurhaliza@siharat.com'),
('PPPK001', 'Budi Santoso, S.Kom.', 'Analis Sistem Informasi', 'Ahli Pertama', 'Bidang Informatika', 'PPPK', '081234567892', 'budi.santoso@siharat.com'),
('198204201999032003', 'Dewi Sartika, S.Sos.', 'Kepala Bidang Komunikasi', 'Pembina / IV/a', 'Bidang Komunikasi', 'PNS', '081234567893', 'dewi.sartika@siharat.com'),
('PPPK002', 'Rizki Pratama, S.Stat.', 'Statistisi Muda', 'Ahli Pertama', 'Bidang Statistik', 'PPPK', '081234567894', 'rizki.pratama@siharat.com'),
('198509101999032004', 'Maya Sari, S.Kom.', 'Analis Kepegawaian', 'Penata Muda Tingkat I / III/b', 'Sekretariat', 'PNS', '081234567895', 'maya.sari@siharat.com'),
('PPPK003', 'Agus Setiawan, S.T.', 'Pranata Komputer', 'Ahli Pertama', 'Bidang Informatika', 'PPPK', '081234567896', 'agus.setiawan@siharat.com'),
('198712151999032005', 'Indah Permata, S.Sos.', 'Kepala Bidang Statistik', 'Pembina / IV/a', 'Bidang Statistik', 'PNS', '081234567897', 'indah.permata@siharat.com'),
('PPPK004', 'Fajar Nugroho, S.Kom.', 'Analis Data', 'Ahli Pertama', 'Bidang Informatika', 'PPPK', '081234567898', 'fajar.nugroho@siharat.com'),
('198903201999032006', 'Sari Dewi, S.E.', 'Bendahara', 'Penata Muda Tingkat I / III/b', 'Sekretariat', 'PNS', '081234567899', 'sari.dewi@siharat.com');

-- Insert sample meetings
INSERT INTO meetings (title, description, meeting_date, location, organizer_id) VALUES
('Rapat Koordinasi Bulanan', 'Rapat koordinasi untuk evaluasi kinerja bulanan', '2024-01-15 14:00:00+07', 'Ruang Rapat Utama', (SELECT id FROM users WHERE username = 'admin')),
('Evaluasi Program Digitalisasi', 'Evaluasi implementasi program digitalisasi', '2024-01-16 09:00:00+07', 'Ruang Rapat Bidang', (SELECT id FROM users WHERE username = 'hr_manager')),
('Rapat Tim IT', 'Rapat koordinasi tim IT untuk pengembangan sistem', '2024-01-17 10:00:00+07', 'Ruang Rapat IT', (SELECT id FROM users WHERE username = 'admin'));

-- Insert sample fuel management
INSERT INTO fuel_management (vehicle_name, fuel_type, quantity, price_per_unit, total_cost, refuel_date, odometer_reading, driver_name, created_by) VALUES
('Mobil Dinas 001', 'Pertalite', 50.00, 10000.00, 500000.00, '2024-01-10 08:00:00+07', 15000, 'Budi Santoso', (SELECT id FROM users WHERE username = 'admin')),
('Mobil Dinas 002', 'Pertalite', 45.00, 10000.00, 450000.00, '2024-01-12 14:00:00+07', 12000, 'Agus Setiawan', (SELECT id FROM users WHERE username = 'admin'));

-- Insert sample electricity management
INSERT INTO electricity_management (building_name, meter_number, previous_reading, current_reading, rate_per_kwh, total_cost, reading_date, created_by) VALUES
('Gedung Utama', 'MTR001', 1000.00, 1200.00, 1500.00, 300000.00, '2024-01-01 00:00:00+07', (SELECT id FROM users WHERE username = 'admin')),
('Gedung Bidang', 'MTR002', 500.00, 650.00, 1500.00, 225000.00, '2024-01-01 00:00:00+07', (SELECT id FROM users WHERE username = 'admin'));

-- ========================================
-- ROW LEVEL SECURITY (RLS)
-- ========================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE meetings ENABLE ROW LEVEL SECURITY;
ALTER TABLE meeting_attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE meeting_minutes ENABLE ROW LEVEL SECURITY;
ALTER TABLE fuel_management ENABLE ROW LEVEL SECURITY;
ALTER TABLE electricity_management ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;

-- RLS Policies for Users
CREATE POLICY "Users can view own profile" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

-- RLS Policies for Employees
CREATE POLICY "Admin can view all employees" ON employees
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE users.id = auth.uid() 
      AND users.role = 'admin'
    )
  );

CREATE POLICY "HR can manage employees" ON employees
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE users.id = auth.uid() 
      AND users.role IN ('admin', 'hr_manager')
    )
  );

-- RLS Policies for Meetings
CREATE POLICY "Users can view meetings" ON meetings
  FOR SELECT USING (true);

CREATE POLICY "Admin can manage meetings" ON meetings
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE users.id = auth.uid() 
      AND users.role = 'admin'
    )
  );

-- RLS Policies for Attendance
CREATE POLICY "Users can view attendance" ON meeting_attendance
  FOR SELECT USING (true);

CREATE POLICY "HR can manage attendance" ON meeting_attendance
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE users.id = auth.uid() 
      AND users.role IN ('admin', 'hr_manager')
    )
  );

-- RLS Policies for Fuel Management
CREATE POLICY "Admin can manage fuel" ON fuel_management
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE users.id = auth.uid() 
      AND users.role = 'admin'
    )
  );

-- RLS Policies for Electricity Management
CREATE POLICY "Admin can manage electricity" ON electricity_management
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE users.id = auth.uid() 
      AND users.role = 'admin'
    )
  );

-- RLS Policies for Reports
CREATE POLICY "Users can view reports" ON reports
  FOR SELECT USING (true);

CREATE POLICY "Admin can manage reports" ON reports
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE users.id = auth.uid() 
      AND users.role = 'admin'
    )
  );

-- ========================================
-- FUNCTIONS AND TRIGGERS
-- ========================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_employees_updated_at BEFORE UPDATE ON employees
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_meetings_updated_at BEFORE UPDATE ON meetings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_meeting_minutes_updated_at BEFORE UPDATE ON meeting_minutes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ========================================
-- VIEWS FOR REPORTING
-- ========================================

-- View for employee statistics
CREATE VIEW employee_stats AS
SELECT 
    employee_type,
    division,
    COUNT(*) as total_employees,
    COUNT(CASE WHEN is_active = true THEN 1 END) as active_employees
FROM employees
GROUP BY employee_type, division;

-- View for meeting statistics
CREATE VIEW meeting_stats AS
SELECT 
    DATE_TRUNC('month', meeting_date) as month,
    COUNT(*) as total_meetings,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed_meetings
FROM meetings
GROUP BY DATE_TRUNC('month', meeting_date);

-- View for fuel consumption
CREATE VIEW fuel_consumption AS
SELECT 
    vehicle_name,
    SUM(quantity) as total_fuel,
    SUM(total_cost) as total_cost,
    COUNT(*) as refuel_count
FROM fuel_management
GROUP BY vehicle_name;

-- View for electricity usage
CREATE VIEW electricity_usage AS
SELECT 
    building_name,
    SUM(usage_amount) as total_usage,
    SUM(total_cost) as total_cost,
    AVG(usage_amount) as avg_usage
FROM electricity_management
GROUP BY building_name;

-- ========================================
-- COMPLETION MESSAGE
-- ========================================
DO $$
BEGIN
    RAISE NOTICE '✅ SI-HARAT Database setup completed successfully!';
    RAISE NOTICE '📊 Tables created: users, employees, meetings, meeting_attendance, meeting_minutes, fuel_management, electricity_management, reports';
    RAISE NOTICE '🔐 Row Level Security enabled on all tables';
    RAISE NOTICE '📈 Indexes created for performance optimization';
    RAISE NOTICE '📋 Sample data inserted';
    RAISE NOTICE '🎯 Ready for production use!';
END $$;
