-- =====================================================
-- ADD SIMPLE_USERS TABLE FOR AGENCY AUTHENTICATION
-- =====================================================

-- Create simple_users table for agency/guest authentication
CREATE TABLE IF NOT EXISTS simple_users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    address TEXT,
    role VARCHAR(50) DEFAULT 'user' CHECK (role IN ('user', 'agency', 'admin', 'guest')),
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended')),
    avatar_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index on email for faster lookups
CREATE INDEX IF NOT EXISTS idx_simple_users_email ON simple_users(email);
CREATE INDEX IF NOT EXISTS idx_simple_users_role ON simple_users(role);

-- Add trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_simple_users_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER simple_users_updated_at
BEFORE UPDATE ON simple_users
FOR EACH ROW
EXECUTE FUNCTION update_simple_users_updated_at();

-- Insert a test agency user (password: agency123)
INSERT INTO simple_users (name, email, password_hash, phone, address, role, status)
VALUES 
    ('SuriStay Agency', 'agency@suristay.com', '$2b$10$LQv3c1yqBWLVHpPjrPyFOe.xjPeZvGcyLz4XAT.uuoiOI.yvF6YAu', '+1-876-555-0001', 'Kingston, Jamaica', 'agency', 'active'),
    ('Test Agency', 'test@agency.com', '$2b$10$LQv3c1yqBWLVHpPjrPyFOe.xjPeZvGcyLz4XAT.uuoiOI.yvF6YAu', '+1-876-555-0002', 'Nassau, Bahamas', 'agency', 'active')
ON CONFLICT (email) DO NOTHING;

COMMIT;

-- Show result
SELECT COUNT(*) as total_simple_users FROM simple_users;
SELECT id, name, email, role, status, created_at FROM simple_users;
