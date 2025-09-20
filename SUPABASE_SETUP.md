# 🗄️ Panduan Setup Database Supabase untuk SI-HARAT

## 📋 Daftar Isi
1. [Setup Awal Supabase](#setup-awal-supabase)
2. [Database Schema](#database-schema)
3. [Tables & Relationships](#tables--relationships)
4. [Sample Data](#sample-data)
5. [API Configuration](#api-configuration)
6. [Authentication Setup](#authentication-setup)
7. [Row Level Security (RLS)](#row-level-security-rls)
8. [Testing & Validation](#testing--validation)

---

## 🚀 Setup Awal Supabase

### 1. Buat Project Supabase
```bash
# Kunjungi: https://supabase.com
# Klik "Start your project"
# Login dengan GitHub/Google
# Pilih "New Project"
```

### 2. Project Configuration
```
Project Name: siharat-database
Database Password: [password yang kuat]
Region: Southeast Asia (Singapore)
Pricing Plan: Free Tier (untuk development)
```

### 3. Install Supabase CLI (Opsional)
```bash
npm install -g supabase
supabase login
supabase init
```

---

## 🏗️ Database Schema

### 1. Users Table
```sql
-- Table untuk data pengguna sistem
CREATE TABLE users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'user',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 2. Employees Table (Data Pegawai)
```sql
-- Table untuk data pegawai ASN
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
```

### 3. Meetings Table (Data Rapat)
```sql
-- Table untuk data rapat
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
```

### 4. Meeting Attendance Table (Absensi Rapat)
```sql
-- Table untuk data kehadiran rapat
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
```

### 5. Meeting Minutes Table (Notulen Rapat)
```sql
-- Table untuk notulen rapat
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
```

### 6. Fuel Management Table (Manajemen BBM)
```sql
-- Table untuk manajemen BBM
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
```

### 7. Electricity Management Table (Manajemen Listrik)
```sql
-- Table untuk manajemen listrik
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
```

### 8. Reports Table (Laporan)
```sql
-- Table untuk laporan
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
```

---

## 🔗 Tables & Relationships

### Foreign Key Relationships:
```sql
-- Users -> Meetings (organizer)
ALTER TABLE meetings ADD CONSTRAINT fk_meetings_organizer 
FOREIGN KEY (organizer_id) REFERENCES users(id);

-- Meetings -> Meeting Attendance
ALTER TABLE meeting_attendance ADD CONSTRAINT fk_attendance_meeting 
FOREIGN KEY (meeting_id) REFERENCES meetings(id) ON DELETE CASCADE;

-- Employees -> Meeting Attendance
ALTER TABLE meeting_attendance ADD CONSTRAINT fk_attendance_employee 
FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE;

-- Meetings -> Meeting Minutes
ALTER TABLE meeting_minutes ADD CONSTRAINT fk_minutes_meeting 
FOREIGN KEY (meeting_id) REFERENCES meetings(id) ON DELETE CASCADE;

-- Users -> Meeting Minutes (created_by)
ALTER TABLE meeting_minutes ADD CONSTRAINT fk_minutes_creator 
FOREIGN KEY (created_by) REFERENCES users(id);
```

### Indexes untuk Performance:
```sql
-- Indexes untuk query optimization
CREATE INDEX idx_employees_nip ON employees(nip);
CREATE INDEX idx_employees_division ON employees(division);
CREATE INDEX idx_employees_type ON employees(employee_type);
CREATE INDEX idx_meetings_date ON meetings(meeting_date);
CREATE INDEX idx_attendance_meeting ON meeting_attendance(meeting_id);
CREATE INDEX idx_attendance_employee ON meeting_attendance(employee_id);
CREATE INDEX idx_fuel_date ON fuel_management(refuel_date);
CREATE INDEX idx_electricity_date ON electricity_management(reading_date);
```

---

## 📊 Sample Data

### 1. Users Sample Data:
```sql
INSERT INTO users (email, username, password_hash, full_name, role) VALUES
('admin@siharat.com', 'admin', '$2a$10$hash...', 'Administrator SI-HARAT', 'admin'),
('hr@siharat.com', 'hr_manager', '$2a$10$hash...', 'Manager HR', 'hr_manager'),
('user@siharat.com', 'user', '$2a$10$hash...', 'User Biasa', 'user');
```

### 2. Employees Sample Data:
```sql
INSERT INTO employees (nip, name, position, rank_class, division, employee_type, phone, email) VALUES
('196512031990031001', 'Dr. Ahmad Hakim, S.Kom., M.T.', 'Kepala Dinas', 'Pembina Utama Muda / IV/c', 'Sekretariat', 'PNS', '081234567890', 'ahmad.hakim@siharat.com'),
('197803151998032002', 'Siti Nurhaliza, S.E.', 'Sekretaris', 'Pembina / IV/a', 'Sekretariat', 'PNS', '081234567891', 'siti.nurhaliza@siharat.com'),
('PPPK001', 'Budi Santoso, S.Kom.', 'Analis Sistem Informasi', 'Ahli Pertama', 'Bidang Informatika', 'PPPK', '081234567892', 'budi.santoso@siharat.com'),
('198204201999032003', 'Dewi Sartika, S.Sos.', 'Kepala Bidang Komunikasi', 'Pembina / IV/a', 'Bidang Komunikasi', 'PNS', '081234567893', 'dewi.sartika@siharat.com'),
('PPPK002', 'Rizki Pratama, S.Stat.', 'Statistisi Muda', 'Ahli Pertama', 'Bidang Statistik', 'PPPK', '081234567894', 'rizki.pratama@siharat.com');
```

### 3. Meetings Sample Data:
```sql
INSERT INTO meetings (title, description, meeting_date, location, organizer_id) VALUES
('Rapat Koordinasi Bulanan', 'Rapat koordinasi untuk evaluasi kinerja bulanan', '2024-01-15 14:00:00+07', 'Ruang Rapat Utama', (SELECT id FROM users WHERE username = 'admin')),
('Evaluasi Program Digitalisasi', 'Evaluasi implementasi program digitalisasi', '2024-01-16 09:00:00+07', 'Ruang Rapat Bidang', (SELECT id FROM users WHERE username = 'hr_manager'));
```

---

## 🔧 API Configuration

### 1. Supabase Client Setup
```javascript
// assets/js/supabase-client.js
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'YOUR_SUPABASE_URL'
const supabaseKey = 'YOUR_SUPABASE_ANON_KEY'

export const supabase = createClient(supabaseUrl, supabaseKey)
```

### 2. Environment Variables
```bash
# .env file
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
VITE_SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

### 3. API Functions Examples
```javascript
// assets/js/api/employees.js
import { supabase } from '../supabase-client.js'

export const employeeAPI = {
  // Get all employees
  async getAll() {
    const { data, error } = await supabase
      .from('employees')
      .select('*')
      .order('name')
    
    if (error) throw error
    return data
  },

  // Get employee by ID
  async getById(id) {
    const { data, error } = await supabase
      .from('employees')
      .select('*')
      .eq('id', id)
      .single()
    
    if (error) throw error
    return data
  },

  // Create new employee
  async create(employeeData) {
    const { data, error } = await supabase
      .from('employees')
      .insert(employeeData)
      .select()
    
    if (error) throw error
    return data[0]
  },

  // Update employee
  async update(id, employeeData) {
    const { data, error } = await supabase
      .from('employees')
      .update(employeeData)
      .eq('id', id)
      .select()
    
    if (error) throw error
    return data[0]
  },

  // Delete employee
  async delete(id) {
    const { error } = await supabase
      .from('employees')
      .delete()
      .eq('id', id)
    
    if (error) throw error
  }
}
```

---

## 🔐 Authentication Setup

### 1. Enable Authentication
```sql
-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE meetings ENABLE ROW LEVEL SECURITY;
ALTER TABLE meeting_attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE meeting_minutes ENABLE ROW LEVEL SECURITY;
ALTER TABLE fuel_management ENABLE ROW LEVEL SECURITY;
ALTER TABLE electricity_management ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
```

### 2. RLS Policies
```sql
-- Users can only see their own data
CREATE POLICY "Users can view own profile" ON users
  FOR SELECT USING (auth.uid() = id);

-- Admin can see all employees
CREATE POLICY "Admin can view all employees" ON employees
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE users.id = auth.uid() 
      AND users.role = 'admin'
    )
  );

-- HR Manager can manage employees
CREATE POLICY "HR can manage employees" ON employees
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE users.id = auth.uid() 
      AND users.role IN ('admin', 'hr_manager')
    )
  );
```

---

## 🧪 Testing & Validation

### 1. Test Database Connection
```javascript
// Test connection
async function testConnection() {
  try {
    const { data, error } = await supabase
      .from('employees')
      .select('count')
    
    if (error) throw error
    console.log('✅ Database connection successful')
  } catch (error) {
    console.error('❌ Database connection failed:', error)
  }
}
```

### 2. Test CRUD Operations
```javascript
// Test CRUD operations
async function testCRUD() {
  try {
    // Create
    const newEmployee = await employeeAPI.create({
      nip: 'TEST001',
      name: 'Test Employee',
      position: 'Test Position',
      division: 'Test Division',
      employee_type: 'PNS'
    })
    console.log('✅ Create successful:', newEmployee)

    // Read
    const employees = await employeeAPI.getAll()
    console.log('✅ Read successful:', employees.length, 'employees')

    // Update
    const updated = await employeeAPI.update(newEmployee.id, {
      name: 'Updated Test Employee'
    })
    console.log('✅ Update successful:', updated)

    // Delete
    await employeeAPI.delete(newEmployee.id)
    console.log('✅ Delete successful')

  } catch (error) {
    console.error('❌ CRUD test failed:', error)
  }
}
```

---

## 📱 Frontend Integration

### 1. Update Dashboard untuk menggunakan Supabase
```javascript
// siharat-dashboard.html - Update JavaScript
import { supabase } from './assets/js/supabase-client.js'
import { employeeAPI } from './assets/js/api/employees.js'

// Load employees from Supabase
async function loadEmployees() {
  try {
    const employees = await employeeAPI.getAll()
    populateTable(employees)
  } catch (error) {
    console.error('Error loading employees:', error)
  }
}
```

### 2. Real-time Updates
```javascript
// Subscribe to real-time changes
const subscription = supabase
  .channel('employees_changes')
  .on('postgres_changes', 
    { event: '*', schema: 'public', table: 'employees' },
    (payload) => {
      console.log('Employee data changed:', payload)
      loadEmployees() // Reload data
    }
  )
  .subscribe()
```

---

## 🚀 Deployment Checklist

### ✅ Pre-deployment:
- [ ] Database schema created
- [ ] Sample data inserted
- [ ] RLS policies configured
- [ ] API functions tested
- [ ] Authentication working
- [ ] Frontend integration complete

### ✅ Production Setup:
- [ ] Environment variables configured
- [ ] SSL certificates setup
- [ ] Backup strategy implemented
- [ ] Monitoring configured
- [ ] Performance optimized

---

## 📞 Support & Resources

- **Supabase Docs**: https://supabase.com/docs
- **SQL Reference**: https://supabase.com/docs/guides/database
- **API Reference**: https://supabase.com/docs/reference
- **Community**: https://github.com/supabase/supabase/discussions

---

**🎉 Selamat! Database SI-HARAT siap digunakan!**
