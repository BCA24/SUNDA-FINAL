-- =====================================================
-- CARIBBEAN REAL ESTATE PLATFORM DATABASE SCHEMA
-- PostgreSQL Database Design
-- =====================================================

-- Enable UUID extension for unique identifiers
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- LOCATION HIERARCHY TABLES
-- =====================================================

-- Countries table
CREATE TABLE countries (
    id SERIAL PRIMARY KEY,
    code VARCHAR(3) UNIQUE NOT NULL, -- ISO country code (JAM, BHS, etc.)
    name VARCHAR(100) NOT NULL,
    region VARCHAR(20) NOT NULL CHECK (region IN ('West', 'East', 'Mainland')),
    currency_code VARCHAR(3) DEFAULT 'USD',
    phone_prefix VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Cities table
CREATE TABLE cities (
    id SERIAL PRIMARY KEY,
    country_id INTEGER REFERENCES countries(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    state_province VARCHAR(100),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    is_capital BOOLEAN DEFAULT FALSE,
    population INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(country_id, name)
);

-- =====================================================
-- USER MANAGEMENT TABLES
-- =====================================================

-- User roles enum
CREATE TYPE user_role AS ENUM ('admin', 'agent', 'user', 'moderator');
CREATE TYPE user_status AS ENUM ('active', 'inactive', 'suspended', 'pending_verification');

-- Users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role user_role DEFAULT 'user',
    status user_status DEFAULT 'pending_verification',
    avatar_url TEXT,
    bio TEXT,
    company_name VARCHAR(200),
    license_number VARCHAR(100), -- For real estate agents
    country_id INTEGER REFERENCES countries(id),
    city_id INTEGER REFERENCES cities(id),
    address TEXT,
    email_verified BOOLEAN DEFAULT FALSE,
    phone_verified BOOLEAN DEFAULT FALSE,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User sessions for authentication
CREATE TABLE user_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Email verification tokens
CREATE TABLE email_verifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(255) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- PROPERTY MANAGEMENT TABLES
-- =====================================================

-- Property types enum
CREATE TYPE property_type AS ENUM (
    'apartment', 'villa', 'house', 'condo', 'townhouse', 
    'penthouse', 'beach_house', 'resort_property', 
    'commercial', 'land_plot', 'warehouse', 'office'
);

-- Property status enum
CREATE TYPE property_status AS ENUM (
    'draft', 'pending_approval', 'active', 'sold', 
    'rented', 'off_market', 'expired', 'rejected'
);

-- Listing type enum
CREATE TYPE listing_type AS ENUM ('sale', 'rent', 'both');

-- Main properties table
CREATE TABLE properties (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    property_type property_type NOT NULL,
    listing_type listing_type NOT NULL,
    status property_status DEFAULT 'draft',
    
    -- Location
    country_id INTEGER REFERENCES countries(id) NOT NULL,
    city_id INTEGER REFERENCES cities(id) NOT NULL,
    address TEXT NOT NULL,
    postal_code VARCHAR(20),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    
    -- Basic details
    bedrooms INTEGER CHECK (bedrooms >= 0),
    bathrooms DECIMAL(3,1) CHECK (bathrooms >= 0), -- Allow half baths (2.5)
    area_sqm DECIMAL(10, 2) CHECK (area_sqm > 0),
    lot_size_sqm DECIMAL(10, 2),
    construction_year INTEGER CHECK (construction_year >= 1800 AND construction_year <= EXTRACT(YEAR FROM CURRENT_DATE) + 5),
    floors INTEGER CHECK (floors > 0),
    
    -- Pricing
    sale_price DECIMAL(12, 2) CHECK (sale_price >= 0),
    rent_price_monthly DECIMAL(10, 2) CHECK (rent_price_monthly >= 0),
    currency_code VARCHAR(3) DEFAULT 'USD',
    price_negotiable BOOLEAN DEFAULT TRUE,
    
    -- Features & Amenities (Boolean flags for filtering)
    near_beach BOOLEAN DEFAULT FALSE,
    ocean_view BOOLEAN DEFAULT FALSE,
    mountain_view BOOLEAN DEFAULT FALSE,
    city_view BOOLEAN DEFAULT FALSE,
    furnished BOOLEAN DEFAULT FALSE,
    has_pool BOOLEAN DEFAULT FALSE,
    has_garden BOOLEAN DEFAULT FALSE,
    has_parking BOOLEAN DEFAULT FALSE,
    has_garage BOOLEAN DEFAULT FALSE,
    has_balcony BOOLEAN DEFAULT FALSE,
    has_terrace BOOLEAN DEFAULT FALSE,
    has_elevator BOOLEAN DEFAULT FALSE,
    has_security BOOLEAN DEFAULT FALSE,
    gated_community BOOLEAN DEFAULT FALSE,
    has_gym BOOLEAN DEFAULT FALSE,
    has_spa BOOLEAN DEFAULT FALSE,
    has_tennis_court BOOLEAN DEFAULT FALSE,
    has_golf_access BOOLEAN DEFAULT FALSE,
    has_marina_access BOOLEAN DEFAULT FALSE,
    pet_friendly BOOLEAN DEFAULT FALSE,
    wheelchair_accessible BOOLEAN DEFAULT FALSE,
    has_solar_power BOOLEAN DEFAULT FALSE,
    has_generator BOOLEAN DEFAULT FALSE,
    has_ac BOOLEAN DEFAULT FALSE,
    has_heating BOOLEAN DEFAULT FALSE,
    has_fireplace BOOLEAN DEFAULT FALSE,
    new_construction BOOLEAN DEFAULT FALSE,
    eco_friendly BOOLEAN DEFAULT FALSE,
    smart_home BOOLEAN DEFAULT FALSE,
    
    -- Contact & Viewing
    contact_phone VARCHAR(20),
    contact_email VARCHAR(255),
    viewing_available BOOLEAN DEFAULT TRUE,
    virtual_tour_url TEXT,
    
    -- SEO & Marketing
    slug VARCHAR(255) UNIQUE,
    meta_title VARCHAR(200),
    meta_description TEXT,
    featured BOOLEAN DEFAULT FALSE,
    featured_until TIMESTAMP,
    
    -- Moderation
    approved_by UUID REFERENCES users(id),
    approved_at TIMESTAMP,
    rejection_reason TEXT,
    
    -- Analytics
    view_count INTEGER DEFAULT 0,
    inquiry_count INTEGER DEFAULT 0,
    favorite_count INTEGER DEFAULT 0,
    
    -- Timestamps
    published_at TIMESTAMP,
    expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Property images table
CREATE TABLE property_images (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID REFERENCES properties(id) ON DELETE CASCADE,
    image_url TEXT NOT NULL,
    thumbnail_url TEXT,
    alt_text VARCHAR(255),
    display_order INTEGER DEFAULT 0,
    is_primary BOOLEAN DEFAULT FALSE,
    file_size INTEGER, -- in bytes
    width INTEGER,
    height INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Property amenities (for complex amenities not covered by boolean flags)
CREATE TABLE property_amenities (
    id SERIAL PRIMARY KEY,
    property_id UUID REFERENCES properties(id) ON DELETE CASCADE,
    amenity_name VARCHAR(100) NOT NULL,
    amenity_category VARCHAR(50), -- 'interior', 'exterior', 'community', 'nearby'
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- SEARCH & FILTERING SUPPORT TABLES
-- =====================================================

-- Saved searches for users
CREATE TABLE saved_searches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    search_criteria JSONB NOT NULL, -- Store filter criteria as JSON
    email_alerts BOOLEAN DEFAULT FALSE,
    alert_frequency VARCHAR(20) DEFAULT 'daily', -- 'immediate', 'daily', 'weekly'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User favorites
CREATE TABLE user_favorites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    property_id UUID REFERENCES properties(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, property_id)
);

-- Property inquiries
CREATE TABLE property_inquiries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID REFERENCES properties(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    message TEXT NOT NULL,
    inquiry_type VARCHAR(50) DEFAULT 'general', -- 'viewing', 'pricing', 'general', 'financing'
    status VARCHAR(20) DEFAULT 'new', -- 'new', 'responded', 'closed'
    responded_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- ANALYTICS & REPORTING TABLES
-- =====================================================

-- Property views tracking
CREATE TABLE property_views (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID REFERENCES properties(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    ip_address INET,
    user_agent TEXT,
    referrer TEXT,
    viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Search analytics
CREATE TABLE search_analytics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    search_criteria JSONB,
    results_count INTEGER,
    ip_address INET,
    searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- SYSTEM CONFIGURATION TABLES
-- =====================================================

-- System settings
CREATE TABLE system_settings (
    key VARCHAR(100) PRIMARY KEY,
    value TEXT,
    description TEXT,
    updated_by UUID REFERENCES users(id),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- User indexes
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_country_city ON users(country_id, city_id);

-- Property indexes
CREATE INDEX idx_properties_status ON properties(status);
CREATE INDEX idx_properties_user_id ON properties(user_id);
CREATE INDEX idx_properties_location ON properties(country_id, city_id);
CREATE INDEX idx_properties_type ON properties(property_type);
CREATE INDEX idx_properties_listing_type ON properties(listing_type);
CREATE INDEX idx_properties_price_sale ON properties(sale_price) WHERE sale_price IS NOT NULL;
CREATE INDEX idx_properties_price_rent ON properties(rent_price_monthly) WHERE rent_price_monthly IS NOT NULL;
CREATE INDEX idx_properties_bedrooms ON properties(bedrooms);
CREATE INDEX idx_properties_bathrooms ON properties(bathrooms);
CREATE INDEX idx_properties_area ON properties(area_sqm);
CREATE INDEX idx_properties_created_at ON properties(created_at);
CREATE INDEX idx_properties_published_at ON properties(published_at);
CREATE INDEX idx_properties_featured ON properties(featured) WHERE featured = TRUE;

-- Location-based search index
CREATE INDEX idx_properties_location_coords ON properties USING GIST(ll_to_earth(latitude, longitude));

-- Boolean feature indexes (for common filters)
CREATE INDEX idx_properties_near_beach ON properties(near_beach) WHERE near_beach = TRUE;
CREATE INDEX idx_properties_ocean_view ON properties(ocean_view) WHERE ocean_view = TRUE;
CREATE INDEX idx_properties_has_pool ON properties(has_pool) WHERE has_pool = TRUE;
CREATE INDEX idx_properties_furnished ON properties(furnished) WHERE furnished = TRUE;
CREATE INDEX idx_properties_gated_community ON properties(gated_community) WHERE gated_community = TRUE;

-- Full-text search indexes
CREATE INDEX idx_properties_search ON properties USING GIN(to_tsvector('english', title || ' ' || COALESCE(description, '')));

-- Image indexes
CREATE INDEX idx_property_images_property_id ON property_images(property_id);
CREATE INDEX idx_property_images_primary ON property_images(property_id, is_primary) WHERE is_primary = TRUE;

-- Analytics indexes
CREATE INDEX idx_property_views_property_id ON property_views(property_id);
CREATE INDEX idx_property_views_viewed_at ON property_views(viewed_at);
CREATE INDEX idx_property_inquiries_property_id ON property_inquiries(property_id);
CREATE INDEX idx_user_favorites_user_id ON user_favorites(user_id);

-- =====================================================
-- TRIGGERS FOR AUTOMATIC UPDATES
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at triggers to relevant tables
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_properties_updated_at BEFORE UPDATE ON properties FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_countries_updated_at BEFORE UPDATE ON countries FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_cities_updated_at BEFORE UPDATE ON cities FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_saved_searches_updated_at BEFORE UPDATE ON saved_searches FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to update property view count
CREATE OR REPLACE FUNCTION increment_property_view_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE properties 
    SET view_count = view_count + 1 
    WHERE id = NEW.property_id;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to increment view count when a view is recorded
CREATE TRIGGER increment_view_count_trigger 
    AFTER INSERT ON property_views 
    FOR EACH ROW EXECUTE FUNCTION increment_property_view_count();

-- Function to update property inquiry count
CREATE OR REPLACE FUNCTION increment_property_inquiry_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE properties 
    SET inquiry_count = inquiry_count + 1 
    WHERE id = NEW.property_id;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to increment inquiry count
CREATE TRIGGER increment_inquiry_count_trigger 
    AFTER INSERT ON property_inquiries 
    FOR EACH ROW EXECUTE FUNCTION increment_property_inquiry_count();

-- Function to update property favorite count
CREATE OR REPLACE FUNCTION update_property_favorite_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE properties 
        SET favorite_count = favorite_count + 1 
        WHERE id = NEW.property_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE properties 
        SET favorite_count = favorite_count - 1 
        WHERE id = OLD.property_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ language 'plpgsql';

-- Triggers for favorite count
CREATE TRIGGER update_favorite_count_insert_trigger 
    AFTER INSERT ON user_favorites 
    FOR EACH ROW EXECUTE FUNCTION update_property_favorite_count();
    
CREATE TRIGGER update_favorite_count_delete_trigger 
    AFTER DELETE ON user_favorites 
    FOR EACH ROW EXECUTE FUNCTION update_property_favorite_count();

-- =====================================================
-- VIEWS FOR COMMON QUERIES
-- =====================================================

-- Active properties with location info
CREATE VIEW active_properties_view AS
SELECT 
    p.*,
    c.name as country_name,
    c.code as country_code,
    c.region,
    c.currency_code as country_currency,
    ct.name as city_name,
    u.first_name || ' ' || u.last_name as owner_name,
    u.email as owner_email,
    u.phone as owner_phone,
    u.company_name,
    (SELECT image_url FROM property_images pi WHERE pi.property_id = p.id AND pi.is_primary = TRUE LIMIT 1) as primary_image
FROM properties p
JOIN countries c ON p.country_id = c.id
JOIN cities ct ON p.city_id = ct.id
JOIN users u ON p.user_id = u.id
WHERE p.status = 'active' 
AND (p.expires_at IS NULL OR p.expires_at > CURRENT_TIMESTAMP);

-- Property search view with all filterable fields
CREATE VIEW property_search_view AS
SELECT 
    p.id,
    p.title,
    p.description,
    p.property_type,
    p.listing_type,
    p.bedrooms,
    p.bathrooms,
    p.area_sqm,
    p.sale_price,
    p.rent_price_monthly,
    p.currency_code,
    p.near_beach,
    p.ocean_view,
    p.furnished,
    p.has_pool,
    p.has_garden,
    p.has_parking,
    p.gated_community,
    p.new_construction,
    p.latitude,
    p.longitude,
    p.view_count,
    p.favorite_count,
    p.created_at,
    p.published_at,
    c.name as country_name,
    c.code as country_code,
    c.region,
    ct.name as city_name,
    (SELECT image_url FROM property_images pi WHERE pi.property_id = p.id AND pi.is_primary = TRUE LIMIT 1) as primary_image,
    (SELECT COUNT(*) FROM property_images pi WHERE pi.property_id = p.id) as image_count
FROM properties p
JOIN countries c ON p.country_id = c.id
JOIN cities ct ON p.city_id = ct.id
WHERE p.status = 'active' 
AND (p.expires_at IS NULL OR p.expires_at > CURRENT_TIMESTAMP);

-- =====================================================
-- COMMENTS
-- =====================================================

COMMENT ON TABLE countries IS 'Caribbean countries and territories';
COMMENT ON TABLE cities IS 'Cities within Caribbean countries';
COMMENT ON TABLE users IS 'Platform users including agents, buyers, and admins';
COMMENT ON TABLE properties IS 'Main property listings table with all filterable attributes';
COMMENT ON TABLE property_images IS 'Property photos and media';
COMMENT ON TABLE property_amenities IS 'Additional property features not covered by boolean flags';
COMMENT ON TABLE user_favorites IS 'User saved/favorite properties';
COMMENT ON TABLE property_inquiries IS 'Contact inquiries for properties';
COMMENT ON TABLE property_views IS 'Property view tracking for analytics';
COMMENT ON TABLE saved_searches IS 'User saved search criteria with alert preferences';

COMMENT ON COLUMN properties.area_sqm IS 'Property area in square meters';
COMMENT ON COLUMN properties.lot_size_sqm IS 'Lot/land size in square meters';
COMMENT ON COLUMN properties.bathrooms IS 'Number of bathrooms (allows half baths like 2.5)';
COMMENT ON COLUMN properties.slug IS 'URL-friendly property identifier';
COMMENT ON COLUMN properties.featured IS 'Premium listing flag';
COMMENT ON COLUMN properties.search_criteria IS 'JSON object containing filter parameters';
