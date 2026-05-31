-- Quick test data for Caribbean Real Estate

-- Create a test user
INSERT INTO users (username, email, password_hash, first_name, last_name, phone, role, status, email_verified, created_at)
VALUES 
('testuser', 'test@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIRk.fJQa6', 'Test', 'User', '+1-876-555-0100', 'user', 'active', TRUE, NOW()),
('testagent', 'agent@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIRk.fJQa6', 'Test', 'Agent', '+1-876-555-0200', 'agency', 'active', TRUE, NOW())
ON CONFLICT (email) DO NOTHING;

-- Get the user ID for creating properties
DO $$
DECLARE
    test_user_id UUID;
    jamaica_id INTEGER;
    bahamas_id INTEGER;
    kingston_id INTEGER;
    nassau_id INTEGER;
BEGIN
    -- Get user ID
    SELECT id INTO test_user_id FROM users WHERE email = 'test@example.com' LIMIT 1;
    
    -- Get country IDs
    SELECT id INTO jamaica_id FROM countries WHERE code = 'JAM';
    SELECT id INTO bahamas_id FROM countries WHERE code = 'BHS';
    
    -- Create cities if they don't exist
    INSERT INTO cities (name, country_id, created_at)
    VALUES ('Kingston', jamaica_id, NOW())
    ON CONFLICT DO NOTHING
    RETURNING id INTO kingston_id;
    
    IF kingston_id IS NULL THEN
        SELECT id INTO kingston_id FROM cities WHERE name = 'Kingston' AND country_id = jamaica_id;
    END IF;
    
    INSERT INTO cities (name, country_id, created_at)
    VALUES ('Nassau', bahamas_id, NOW())
    ON CONFLICT DO NOTHING
    RETURNING id INTO nassau_id;
    
    IF nassau_id IS NULL THEN
        SELECT id INTO nassau_id FROM cities WHERE name = 'Nassau' AND country_id = bahamas_id;
    END IF;
    
    -- Create sample properties in Jamaica
    INSERT INTO properties (
        user_id, title, description, property_type, listing_type, status,
        country_id, city_id, address, latitude, longitude,
        bedrooms, bathrooms, area_sqm, construction_year,
        sale_price, currency_code,
        near_beach, ocean_view, has_pool, has_parking,
        contact_phone, contact_email, published_at, created_at
    ) VALUES
    (test_user_id, 'Beautiful Beach Villa in Jamaica', 'Stunning oceanfront villa with panoramic views', 'villa', 'sale', 'active',
     jamaica_id, kingston_id, '123 Beach Road, Kingston', 18.0179, -76.8099,
     4, 3, 250.0, 2020,
     450000, 'USD',
     TRUE, TRUE, TRUE, TRUE,
     '+1-876-555-0100', 'test@example.com', NOW(), NOW()),
     
    (test_user_id, 'Modern Apartment in Kingston', 'Spacious 2-bedroom apartment in city center', 'apartment', 'sale', 'active',
     jamaica_id, kingston_id, '456 Main Street, Kingston', 18.0179, -76.8099,
     2, 2, 120.0, 2021,
     180000, 'USD',
     FALSE, FALSE, FALSE, TRUE,
     '+1-876-555-0100', 'test@example.com', NOW(), NOW()),
     
    (test_user_id, 'Luxury House with Pool', 'Beautiful family home with private pool', 'house', 'sale', 'active',
     jamaica_id, kingston_id, '789 Garden Ave, Kingston', 18.0179, -76.8099,
     3, 2.5, 180.0, 2019,
     320000, 'USD',
     FALSE, FALSE, TRUE, TRUE,
     '+1-876-555-0100', 'test@example.com', NOW(), NOW()),
     
    -- Properties in Bahamas
    (test_user_id, 'Paradise Island Condo', 'Beachfront condo with amazing views', 'condo', 'sale', 'active',
     bahamas_id, nassau_id, '100 Paradise Dr, Nassau', 25.0833, -77.35,
     2, 2, 150.0, 2022,
     550000, 'BSD',
     TRUE, TRUE, TRUE, TRUE,
     '+1-242-555-0100', 'test@example.com', NOW(), NOW()),
     
    (test_user_id, 'Nassau Beach House', 'Charming beach house steps from ocean', 'house', 'sale', 'active',
     bahamas_id, nassau_id, '200 Ocean Blvd, Nassau', 25.0833, -77.35,
     3, 2, 200.0, 2018,
     675000, 'BSD',
     TRUE, TRUE, FALSE, TRUE,
     '+1-242-555-0100', 'test@example.com', NOW(), NOW())
    ON CONFLICT DO NOTHING;
    
END $$;

-- Verify what was created
SELECT 'Users created:' as info, COUNT(*) as count FROM users;
SELECT 'Properties created:' as info, COUNT(*) as count FROM properties WHERE status = 'active';
SELECT 'Cities created:' as info, COUNT(*) as count FROM cities;
