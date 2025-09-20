# 🚀 SI-HARAT Quick Start Guide

## 📋 Langkah-langkah Setup Supabase

### 1. Buat Project Supabase
```bash
# Kunjungi: https://supabase.com
# Klik "Start your project"
# Login dengan GitHub/Google
# Pilih "New Project"
```

### 2. Konfigurasi Project
```
Project Name: siharat-database
Database Password: [password yang kuat]
Region: Southeast Asia (Singapore)
Pricing Plan: Free Tier
```

### 3. Setup Database
```sql
-- Copy dan paste script dari file database/setup.sql
-- Jalankan di SQL Editor di Supabase Dashboard
```

### 4. Konfigurasi Environment
```javascript
// Edit file config/environment.js
// Ganti dengan URL dan Key dari project Supabase Anda
const config = {
    supabase: {
        url: 'https://your-project.supabase.co',
        anonKey: 'your_anon_key_here',
        serviceRoleKey: 'your_service_role_key_here'
    }
}
```

### 5. Update Dashboard
```html
<!-- Tambahkan script di siharat-dashboard.html -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<script src="assets/js/supabase-client.js"></script>
<script src="config/environment.js"></script>
```

### 6. Test Connection
```javascript
// Buka browser console dan test
SupabaseAPI.testConnection()
```

---

## 🔧 Konfigurasi Supabase

### 1. Database URL & Keys
```
URL: https://your-project.supabase.co
Anon Key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Service Role Key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 2. Authentication Setup
```sql
-- Enable authentication
-- Go to Authentication > Settings
-- Enable Email/Password authentication
```

### 3. Row Level Security
```sql
-- RLS sudah diaktifkan di setup.sql
-- Pastikan policies sudah dibuat
```

---

## 📱 Frontend Integration

### 1. Update Dashboard JavaScript
```javascript
// Ganti fungsi loadEmployees() di siharat-dashboard.html
async function loadEmployees() {
    try {
        const employees = await SupabaseAPI.employee.getAll()
        populateTable(employees)
    } catch (error) {
        console.error('Error loading employees:', error)
    }
}
```

### 2. Real-time Updates
```javascript
// Subscribe to real-time changes
const subscription = SupabaseAPI.realtime.subscribeToEmployees((payload) => {
    console.log('Employee data changed:', payload)
    loadEmployees() // Reload data
})
```

### 3. Authentication Integration
```javascript
// Login function
async function loginUser(email, password) {
    try {
        const { data, error } = await SupabaseAPI.auth.signIn(email, password)
        if (error) throw error
        
        // Redirect to dashboard
        window.location.href = 'siharat-dashboard.html'
    } catch (error) {
        console.error('Login failed:', error)
    }
}
```

---

## 🧪 Testing

### 1. Test Database Connection
```javascript
// Test di browser console
SupabaseAPI.testConnection()
```

### 2. Test CRUD Operations
```javascript
// Test create employee
const newEmployee = await SupabaseAPI.employee.create({
    nip: 'TEST001',
    name: 'Test Employee',
    position: 'Test Position',
    division: 'Test Division',
    employee_type: 'PNS'
})

// Test read employees
const employees = await SupabaseAPI.employee.getAll()

// Test update employee
const updated = await SupabaseAPI.employee.update(newEmployee.id, {
    name: 'Updated Test Employee'
})

// Test delete employee
await SupabaseAPI.employee.delete(newEmployee.id)
```

### 3. Test Real-time
```javascript
// Test real-time subscription
const subscription = SupabaseAPI.realtime.subscribeToEmployees((payload) => {
    console.log('Real-time update:', payload)
})
```

---

## 🚨 Troubleshooting

### 1. Connection Issues
```javascript
// Check if Supabase is loaded
if (typeof SupabaseAPI === 'undefined') {
    console.error('Supabase API not loaded')
}

// Check configuration
console.log('Config:', window.SIHARAT_CONFIG)
```

### 2. Authentication Issues
```javascript
// Check current user
const user = await SupabaseAPI.auth.getCurrentUser()
console.log('Current user:', user)
```

### 3. RLS Issues
```sql
-- Check RLS policies
SELECT * FROM pg_policies WHERE tablename = 'employees';
```

---

## 📊 Sample Data

### 1. Employees Data
- 10 sample employees (PNS dan PPPK)
- Various divisions
- Complete contact information

### 2. Meetings Data
- 3 sample meetings
- Different statuses
- Various organizers

### 3. Utility Data
- Fuel management records
- Electricity usage data
- Cost calculations

---

## 🎯 Next Steps

### 1. Customize Data
- Update employee information
- Add more meetings
- Configure utility rates

### 2. Add Features
- File upload for documents
- Email notifications
- Advanced reporting

### 3. Deploy
- Setup production environment
- Configure domain
- Enable SSL

---

## 📞 Support

- **Supabase Docs**: https://supabase.com/docs
- **SQL Reference**: https://supabase.com/docs/guides/database
- **API Reference**: https://supabase.com/docs/reference

---

**🎉 Selamat! SI-HARAT siap digunakan dengan Supabase!**
