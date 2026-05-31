-- User Management System for SuriStay Caribbean
-- Two-tier system: Agency (can add properties) and Guest (view only)

-- Drop existing tables if they exist
DROP TABLE IF EXISTS user_sessions CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Create users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255),
    phone VARCHAR(50),
    role VARCHAR(20) NOT NULL CHECK (role IN ('agency', 'guest')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    -- Agency-specific fields
    agency_name VARCHAR(255),
    agency_license VARCHAR(100),
    agency_address TEXT,
    -- Metadata
    profile_image_url TEXT,
    preferences JSONB DEFAULT '{}'::jsonb
);

-- Create sessions table for managing user sessions
CREATE TABLE user_sessions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    session_token VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    is_valid BOOLEAN DEFAULT true
);

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_sessions_token ON user_sessions(session_token);
CREATE INDEX idx_sessions_user_id ON user_sessions(user_id);

-- Create function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for users table
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert sample users for testing
-- Password for all test users: "password123" (hashed with bcrypt)
INSERT INTO users (email, password_hash, full_name, phone, role, agency_name, agency_license) VALUES
('agency@suristay.com', '$2b$10$rQ8K9vZ8kGxJ.5wXvZJ8H.xK9vZ8kGxJ.5wXvZJ8H.xK9vZ8kGxJ.u', 'Caribbean Realty', '+1-868-555-0100', 'agency', 'Caribbean Realty Agency', 'CRA-2024-001'),
('agency2@suristay.com', '$2b$10$rQ8K9vZ8kGxJ.5wXvZJ8H.xK9vZ8kGxJ.5wXvZJ8H.xK9vZ8kGxJ.u', 'Island Properties', '+1-876-555-0200', 'agency', 'Island Properties Ltd', 'IPL-2024-002'),
('guest@suristay.com', '$2b$10$rQ8K9vZ8kGxJ.5wXvZJ8H.xK9vZ8kGxJ.5wXvZJ8H.xK9vZ8kGxJ.u', 'John Guest', '+1-868-555-0300', 'guest', NULL, NULL),
('guest2@suristay.com', '$2b$10$rQ8K9vZ8kGxJ.5wXvZJ8H.xK9vZ8kGxJ.5wXvZJ8H.xK9vZ8kGxJ.u', 'Jane Tourist', '+1-246-555-0400', 'guest', NULL, NULL);

-- Grant permissions
GRANT ALL PRIVILEGES ON TABLE users TO berk;
GRANT ALL PRIVILEGES ON TABLE user_sessions TO berk;
GRANT USAGE, SELECT ON SEQUENCE users_id_seq TO berk;
GRANT USAGE, SELECT ON SEQUENCE user_sessions_id_seq TO berk;

-- Create view for safe user data (without password hash)
CREATE OR REPLACE VIEW user_profiles AS
SELECT 
    id,
    email,
    full_name,
    phone,
    role,
    created_at,
    last_login,
    is_active,
    agency_name,
    agency_license,
    agency_address,
    profile_image_url,
    preferences
FROM users;

GRANT SELECT ON user_profiles TO berk;

COMMENT ON TABLE users IS 'User accounts with role-based access control';
COMMENT ON COLUMN users.role IS 'User role: agency (can add properties) or guest (view only)';
COMMENT ON TABLE user_sessions IS 'Active user sessions for authentication';
