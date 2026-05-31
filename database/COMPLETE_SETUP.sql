0-- =====================================================
-- COMPLETE DATABASE SETUP FOR CARIBBEAN REAL ESTATE
-- Run this ONE file to set up everything!
-- =====================================================

-- Drop existing tables (clean slate)
DROP TABLE IF EXISTS property_images CASCADE;
DROP TABLE IF EXISTS property_amenities CASCADE;
DROP TABLE IF EXISTS property_views CASCADE;
DROP TABLE IF EXISTS property_inquiries CASCADE;
DROP TABLE IF EXISTS user_favorites CASCADE;
DROP TABLE IF EXISTS saved_searches CASCADE;
DROP TABLE IF EXISTS properties CASCADE;
DROP TABLE IF EXISTS simple_users CASCADE;
DROP TABLE IF EXISTS user_sessions CASCADE;
DROP TABLE IF EXISTS email_verifications CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS cities CASCADE;
DROP TABLE IF EXISTS countries CASCADE;

-- =====================================================
-- 1. SIMPLE_USERS TABLE (for agency authentication)
-- =====================================================
CREATE TABLE simple_users (
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

-- Insert test agency accounts (password: agency123)
INSERT INTO simple_users (name, email, password_hash, phone, address, role, status) VALUES 
('SuriStay Agency', 'agency@suristay.com', '$2b$10$LQv3c1yqBWLVHpPjrPyFOe.xjPeZvGcyLz4XAT.uuoiOI.yvF6YAu', '+1-876-555-0001', 'Kingston, Jamaica', 'agency', 'active'),
('Test Agency', 'test@agency.com', '$2b$10$LQv3c1yqBWLVHpPjrPyFOe.xjPeZvGcyLz4XAT.uuoiOI.yvF6YAu', '+1-876-555-0002', 'Nassau, Bahamas', 'agency', 'active');

-- =====================================================
-- 2. COUNTRIES TABLE
-- =====================================================
CREATE TABLE countries (
    id SERIAL PRIMARY KEY,
    code VARCHAR(3) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(50),
    currency_code VARCHAR(3),
    phone_prefix VARCHAR(20)
);

INSERT INTO countries (code, name, region, currency_code, phone_prefix) VALUES
('JAM', 'Jamaica', 'West', 'USD', '+1-876'),
('BHS', 'Bahamas', 'West', 'BSD', '+1-242'),
('BRB', 'Barbados', 'East', 'BBD', '+1-246'),
('TTO', 'Trinidad and Tobago', 'West', 'TTD', '+1-868');

-- =====================================================
-- 3. CITIES TABLE
-- =====================================================
CREATE TABLE cities (
    id SERIAL PRIMARY KEY,
    country_id INTEGER REFERENCES countries(id),
    name VARCHAR(100) NOT NULL,
    state_province VARCHAR(100),
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7),
    is_capital BOOLEAN DEFAULT FALSE,
    population INTEGER
);

INSERT INTO cities (country_id, name, state_province, latitude, longitude, is_capital, population) VALUES
(1, 'Kingston', 'Kingston Parish', 18.0179, -76.8099, TRUE, 937700),
(1, 'Montego Bay', 'Saint James Parish', 18.4762, -77.8939, FALSE, 110115),
(2, 'Nassau', 'New Providence', 25.0834, -77.3504, TRUE, 274400),
(3, 'Bridgetown', 'Saint Michael', 13.0969, -59.6145, TRUE, 110000);

-- =====================================================
-- 4. USERS TABLE (for properties ownership)
-- =====================================================
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(50),
    role VARCHAR(50) DEFAULT 'user',
    status VARCHAR(50) DEFAULT 'active',
    company_name VARCHAR(255),
    license_number VARCHAR(100),
    country_id INTEGER REFERENCES countries(id),
    city_id INTEGER REFERENCES cities(id),
    email_verified BOOLEAN DEFAULT FALSE,
    phone_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert a default agent (password: agent123)
INSERT INTO users (id, username, email, password_hash, first_name, last_name, phone, role, status, company_name, country_id, city_id, email_verified) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'marcus', 'agent.jamaica@realty.com', '$2b$12$LQv3c1yqBWLVHpPjrPyFOe.xjPeZvGcyLz4XAT.uuoiOI.yvF6YAu', 'Marcus', 'Campbell', '+1-876-555-0101', 'agent', 'active', 'Jamaica Premier Realty', 1, 1, TRUE);

-- =====================================================
-- 5. PROPERTIES TABLE
-- =====================================================
CREATE TABLE properties (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    property_type VARCHAR(50),
    listing_type VARCHAR(50) DEFAULT 'sale',
    status VARCHAR(50) DEFAULT 'active',
    country_id INTEGER REFERENCES countries(id),
    city_id INTEGER REFERENCES cities(id),
    address TEXT,
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7),
    bedrooms INTEGER,
    bathrooms DECIMAL(3, 1),
    area_sqm DECIMAL(10, 2),
    construction_year INTEGER,
    sale_price DECIMAL(12, 2),
    rent_price_monthly DECIMAL(10, 2),
    currency_code VARCHAR(3) DEFAULT 'USD',
    near_beach BOOLEAN DEFAULT FALSE,
    ocean_view BOOLEAN DEFAULT FALSE,
    furnished BOOLEAN DEFAULT FALSE,
    has_pool BOOLEAN DEFAULT FALSE,
    has_garden BOOLEAN DEFAULT FALSE,
    has_parking BOOLEAN DEFAULT FALSE,
    gated_community BOOLEAN DEFAULT FALSE,
    new_construction BOOLEAN DEFAULT FALSE,
    contact_phone VARCHAR(50),
    contact_email VARCHAR(255),
    published_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 6. PROPERTY_IMAGES TABLE
-- =====================================================
CREATE TABLE property_images (
    id SERIAL PRIMARY KEY,
    property_id UUID REFERENCES properties(id) ON DELETE CASCADE,
    image_url TEXT NOT NULL,
    thumbnail_url TEXT,
    alt_text VARCHAR(255),
    display_order INTEGER DEFAULT 0,
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 7. INSERT SAMPLE PROPERTIES
-- =====================================================

-- Jamaica Properties
INSERT INTO properties (
    id, user_id, title, description, property_type, listing_type, status,
    country_id, city_id, address, latitude, longitude,
    bedrooms, bathrooms, area_sqm, construction_year,
    sale_price, currency_code,
    near_beach, ocean_view, furnished, has_pool, has_garden, has_parking, gated_community,
    contact_phone, contact_email, published_at, created_at
) VALUES
('650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 
'Luxury Beachfront Villa in Montego Bay', 
'Stunning 4-bedroom villa with private beach access, infinity pool, and panoramic ocean views.',
'villa', 'sale', 'active', 1, 2, 'Rose Hall, Montego Bay', 18.4762, -77.8939,
4, 3, 350, 2018, 1250000, 'USD',
TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE,
'+1-876-555-0123', 'info@jamaicavillas.com', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

('650e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001',
'Modern Apartment in Kingston',
'Contemporary 2-bedroom apartment in the heart of Kingston with city views.',
'apartment', 'sale', 'active', 1, 1, 'New Kingston', 18.0179, -76.8099,
2, 2, 120, 2023, 185000, 'USD',
FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE,
'+1-876-555-0124', 'sales@kingstonapts.com', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- Bahamas Properties
('650e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440001',
'Paradise Island Penthouse',
'Exclusive penthouse with 360-degree ocean views and private rooftop terrace.',
'penthouse', 'sale', 'active', 2, 3, 'Paradise Island, Nassau', 25.0834, -77.3504,
5, 4, 450, 2020, 2800000, 'USD',
TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, TRUE,
'+1-242-555-0125', 'luxury@paradiseisland.com', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Show results
SELECT 'Setup Complete!' as status;
SELECT COUNT(*) as total_countries FROM countries;
SELECT COUNT(*) as total_cities FROM cities;
SELECT COUNT(*) as total_agencies FROM simple_users WHERE role='agency';
SELECT COUNT(*) as total_properties FROM properties;

COMMIT;
