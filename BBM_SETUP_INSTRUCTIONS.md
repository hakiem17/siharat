# BBM Database Setup Instructions

## Overview
This document provides instructions for setting up the database tables required for the BBM (Bahan Bakar Minyak) management system in SI-HARAT.

## Required Tables

### 1. Vehicles Table
The `vehicles` table stores information about all vehicles in the organization.

```sql
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
```

### 2. Log Pengisian BBM Table
The `log_pengisian_bbm` table stores fuel refill logs.

```sql
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
```

## Setup Steps

### Option 1: Using Supabase Dashboard
1. Go to your Supabase project dashboard
2. Navigate to the SQL Editor
3. Copy and paste the SQL from `database/bbm_tables.sql`
4. Execute the SQL script

### Option 2: Manual Setup
1. Run the SQL commands from `database/bbm_tables.sql` in your database
2. Verify tables are created successfully
3. Test the BBM dashboard functionality

## Testing the Vehicle Entry Functionality

### Using the Main Dashboard
1. Open `dashboard-bbm.html` in your browser
2. Click "Tambah Kendaraan" button
3. Fill in the vehicle information
4. Click "Simpan Kendaraan"
5. Verify the vehicle appears in the vehicle dropdown

## Features Implemented

### Vehicle Entry Form
- ✅ Nomor Polisi (License Plate) - Required, auto-uppercase
- ✅ Merk Kendaraan (Vehicle Brand) - Required
- ✅ Model Kendaraan (Vehicle Model) - Required
- ✅ Jenis Kendaraan (Vehicle Type) - Required, dropdown selection
- ✅ Tahun Pembuatan (Manufacturing Year) - Required, validation
- ✅ Status Aktif (Active Status) - Checkbox, default true
- ✅ Keterangan (Additional Notes) - Optional

### Validation
- ✅ Required field validation
- ✅ License plate format validation
- ✅ Year range validation (1990-2025)
- ✅ Duplicate license plate check
- ✅ Auto-calculation of total cost for fuel logs

### Database Integration
- ✅ Supabase client integration
- ✅ Error handling and user feedback
- ✅ Real-time form validation
- ✅ Success/error notifications

## Troubleshooting

### Common Issues

1. **"Table does not exist" error**
   - Solution: Run the SQL script from `database/bbm_tables.sql`

2. **"Permission denied" error**
   - Solution: Check RLS policies and user permissions in Supabase

3. **"Connection failed" error**
   - Solution: Verify Supabase configuration in `config/environment.js`

4. **Form validation errors**
   - Solution: Ensure all required fields are filled correctly

### Debug Steps
1. Check browser console for JavaScript errors
2. Verify Supabase connection in network tab
3. Test database connection using setup tool
4. Check table existence and permissions

## Next Steps

After successful setup:
1. Test vehicle entry functionality
2. Test fuel log entry functionality
3. Verify data persistence
4. Test user permissions and access control
5. Deploy to production environment

## Support

For technical support or questions:
- Check the browser console for error messages
- Verify database table structure matches requirements
- Test with sample data first
- Contact system administrator for database access issues
