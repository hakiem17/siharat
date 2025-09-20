-- =====================================================
-- INSERT ADMIN USER (SIMPLE VERSION)
-- =====================================================

-- Insert admin user dengan password hash sederhana
INSERT INTO users (
    email,
    username,
    password_hash,
    full_name,
    role,
    is_active
) VALUES (
    'admin@hakiem.com',
    'admin',
    'siharat123#', -- Password plain text untuk testing
    'Admin SI-HARAT',
    'admin',
    true
);

-- Insert additional test users
INSERT INTO users (
    email,
    username,
    password_hash,
    full_name,
    role,
    is_active
) VALUES (
    'manager@hakiem.com',
    'manager',
    'manager123',
    'Manager SI-HARAT',
    'manager',
    true
),
(
    'operator@hakiem.com',
    'operator',
    'operator123',
    'Operator SI-HARAT',
    'operator',
    true
);

-- Verify the inserted users
SELECT 
    id,
    email,
    username,
    full_name,
    role,
    is_active,
    created_at
FROM users
ORDER BY created_at DESC;

-- Show success message
DO $$
BEGIN
    RAISE NOTICE 'Admin user berhasil ditambahkan!';
    RAISE NOTICE 'Email: admin@hakiem.com';
    RAISE NOTICE 'Password: siharat123#';
    RAISE NOTICE 'Role: admin';
    RAISE NOTICE 'Test users juga telah ditambahkan untuk testing';
END $$;
