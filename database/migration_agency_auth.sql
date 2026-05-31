-- =====================================================
-- MIGRATION: Add agency role and guest role support
-- =====================================================

-- Add 'agency' and 'guest' to the user_role enum
ALTER TYPE user_role ADD VALUE 'agency';
ALTER TYPE user_role ADD VALUE 'guest';

-- Create a simplified users table for our agency auth system
-- We'll use this alongside the existing complex users table
CREATE TABLE IF NOT EXISTS simple_users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    role VARCHAR(20) NOT NULL DEFAULT 'guest',
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert a test agency user
INSERT INTO simple_users (name, email, password_hash, phone, address, role) 
VALUES (
    'Test Agency', 
    'agency@test.com', 
    '$2b$10$example.hash.for.password123', 
    '+1-555-0123',
    '123 Caribbean Street, Kingston, Jamaica',
    'agency'
) ON CONFLICT (email) DO NOTHING;

-- Insert a test admin user  
INSERT INTO simple_users (name, email, password_hash, phone, address, role)
VALUES (
    'Admin User',
    'admin@test.com', 
    '$2b$10$example.hash.for.admin123',
    '+1-555-0124',
    'Admin Office, Nassau, Bahamas',
    'agency'
) ON CONFLICT (email) DO NOTHING;

COMMENT ON TABLE simple_users IS 'Simplified user table for agency authentication system';