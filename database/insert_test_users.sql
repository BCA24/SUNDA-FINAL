-- Insert Test Users for SuriStay Caribbean
-- Run this after creating the users table

-- Simple password hash for 'password123'
-- This is for TESTING ONLY - in production use proper bcrypt hashing

-- First, clear any existing test users to avoid conflicts
DELETE FROM user_sessions WHERE user_id IN (SELECT id FROM users WHERE email LIKE '%@test.suristay.com');
DELETE FROM users WHERE email LIKE '%@test.suristay.com';

-- Insert AGENCY test accounts
INSERT INTO users (email, password_hash, full_name, phone, role, agency_name, agency_license) VALUES
('berkbv@live.nl', 'berkbc123', 'Berk BV', '+31-6-12345678', 'agency', 'Berk BV Real Estate', 'BERK-2024-001'),
('agency@test.suristay.com', 'password123', 'SuriStay Realty', '+1-868-555-1000', 'agency', 'SuriStay Realty Agency', 'SRA-2024-001'),
('agency2@test.suristay.com', 'password123', 'Caribbean Properties Ltd', '+1-876-555-2000', 'agency', 'Caribbean Properties Ltd', 'CPL-2024-002');

-- Insert GUEST test accounts  
INSERT INTO users (email, password_hash, full_name, phone, role) VALUES
('guest@test.suristay.com', 'password123', 'John Guest', '+1-868-555-4000', 'guest'),
('tourist@test.suristay.com', 'password123', 'Jane Tourist', '+1-246-555-5000', 'guest');

-- Display the created accounts
SELECT 
    email,
    full_name,
    role,
    agency_name,
    'password123' as password,
    created_at
FROM users 
WHERE email LIKE '%@test.suristay.com'
ORDER BY role DESC, email;

-- Success message
DO $$
BEGIN
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Test Users Created Successfully!';
    RAISE NOTICE '========================================';
    RAISE NOTICE '';
    RAISE NOTICE 'AGENCY ACCOUNTS (Can add properties):';
    RAISE NOTICE '- agency@test.suristay.com / password123';
    RAISE NOTICE '- agency2@test.suristay.com / password123';
    RAISE NOTICE '- berk@test.suristay.com / password123';
    RAISE NOTICE '';
    RAISE NOTICE 'GUEST ACCOUNTS (View only):';
    RAISE NOTICE '- guest@test.suristay.com / password123';
    RAISE NOTICE '- tourist@test.suristay.com / password123';
    RAISE NOTICE '';
    RAISE NOTICE '========================================';
END $$;
