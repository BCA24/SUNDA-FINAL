-- =====================================================
-- CARIBBEAN REAL ESTATE PLATFORM SAMPLE DATA
-- PostgreSQL Sample Data Initialization
-- =====================================================

-- Clear existing data (in correct order due to foreign key constraints)
DELETE FROM property_images;
DELETE FROM property_amenities;
DELETE FROM property_views;
DELETE FROM property_inquiries;
DELETE FROM user_favorites;
DELETE FROM saved_searches;
DELETE FROM properties;
DELETE FROM user_sessions;
DELETE FROM email_verifications;
DELETE FROM users;
DELETE FROM cities;
DELETE FROM countries;
DELETE FROM system_settings;

-- Reset sequences
ALTER SEQUENCE countries_id_seq RESTART WITH 1;
ALTER SEQUENCE cities_id_seq RESTART WITH 1;
ALTER SEQUENCE property_amenities_id_seq RESTART WITH 1;

-- =====================================================
-- COUNTRIES DATA
-- =====================================================

INSERT INTO countries (code, name, region, currency_code, phone_prefix) VALUES
-- West Region
('JAM', 'Jamaica', 'West', 'USD', '+1-876'),
('BHS', 'Bahamas', 'West', 'BSD', '+1-242'),
('CUB', 'Cuba', 'West', 'CUP', '+53'),
('HTI', 'Haiti', 'West', 'HTG', '+509'),
('DOM', 'Dominican Republic', 'West', 'DOP', '+1-809'),
('PRI', 'Puerto Rico', 'West', 'USD', '+1-787'),
('TTO', 'Trinidad and Tobago', 'West', 'TTD', '+1-868'),
('CUW', 'Curaçao', 'West', 'ANG', '+599'),
('ABW', 'Aruba', 'West', 'AWG', '+297'),

-- East Region
('BRB', 'Barbados', 'East', 'BBD', '+1-246'),
('LCA', 'Saint Lucia', 'East', 'XCD', '+1-758'),
('GRD', 'Grenada', 'East', 'XCD', '+1-473'),
('VCT', 'Saint Vincent and the Grenadines', 'East', 'XCD', '+1-784'),
('DMA', 'Dominica', 'East', 'XCD', '+1-767'),
('ATG', 'Antigua and Barbuda', 'East', 'XCD', '+1-268'),
('KNA', 'Saint Kitts and Nevis', 'East', 'XCD', '+1-869'),
('MTQ', 'Martinique', 'East', 'EUR', '+596'),
('GLP', 'Guadeloupe', 'East', 'EUR', '+590'),
('VGB', 'British Virgin Islands', 'East', 'USD', '+1-284'),
('VIR', 'US Virgin Islands', 'East', 'USD', '+1-340'),

-- Mainland Region
('GUY', 'Guyana', 'Mainland', 'GYD', '+592'),
('SUR', 'Suriname', 'Mainland', 'SRD', '+597'),
('GUF', 'French Guiana', 'Mainland', 'EUR', '+594'),
('BLZ', 'Belize', 'Mainland', 'BZD', '+501');

-- =====================================================
-- CITIES DATA
-- =====================================================

INSERT INTO cities (country_id, name, state_province, latitude, longitude, is_capital, population) VALUES
-- Jamaica
(1, 'Kingston', 'Kingston Parish', 18.0179, -76.8099, TRUE, 937700),
(1, 'Montego Bay', 'Saint James Parish', 18.4762, -77.8939, FALSE, 110115),
(1, 'Spanish Town', 'Saint Catherine Parish', 17.9909, -76.9573, FALSE, 147152),
(1, 'Portmore', 'Saint Catherine Parish', 17.9554, -76.8801, FALSE, 182153),
(1, 'Ocho Rios', 'Saint Ann Parish', 18.4078, -77.1031, FALSE, 16671),
(1, 'Negril', 'Westmoreland Parish', 18.2677, -78.3489, FALSE, 3957),
(1, 'Port Antonio', 'Portland Parish', 18.1747, -76.4501, FALSE, 14541),
(1, 'Mandeville', 'Manchester Parish', 18.0456, -77.5019, FALSE, 49695),

-- Bahamas
(2, 'Nassau', 'New Providence', 25.0834, -77.3504, TRUE, 274400),
(2, 'Freeport', 'Grand Bahama', 26.5384, -78.6569, FALSE, 26910),
(2, 'West End', 'Grand Bahama', 26.6862, -78.9756, FALSE, 12724),
(2, 'Cooper\'s Town', 'Abaco', 26.8821, -77.5152, FALSE, 8413),
(2, 'Marsh Harbour', 'Abaco', 26.5412, -77.0636, FALSE, 5314),

-- Cuba
(3, 'Havana', 'La Habana', 23.1136, -82.3666, TRUE, 2130081),
(3, 'Santiago de Cuba', 'Santiago de Cuba', 20.0247, -75.8219, FALSE, 431272),
(3, 'Camagüey', 'Camagüey', 21.3809, -77.9169, FALSE, 301574),
(3, 'Holguín', 'Holguín', 20.8872, -76.2633, FALSE, 294002),
(3, 'Guantánamo', 'Guantánamo', 20.1442, -75.2096, FALSE, 228436),

-- Haiti
(4, 'Port-au-Prince', 'Ouest', 18.5944, -72.3074, TRUE, 987310),
(4, 'Cap-Haïtien', 'Nord', 19.7570, -72.2014, FALSE, 274404),
(4, 'Delmas', 'Ouest', 18.5456, -72.3020, FALSE, 377187),
(4, 'Carrefour', 'Ouest', 18.5413, -72.3979, FALSE, 511345),

-- Dominican Republic
(5, 'Santo Domingo', 'Distrito Nacional', 18.4861, -69.9312, TRUE, 965040),
(5, 'Santiago', 'Santiago', 19.4517, -70.6970, FALSE, 550753),
(5, 'Santo Domingo Este', 'Santo Domingo', 18.4882, -69.8570, FALSE, 700000),
(5, 'Santo Domingo Norte', 'Santo Domingo', 18.5601, -69.9097, FALSE, 558309),
(5, 'Punta Cana', 'La Altagracia', 18.5601, -68.3725, FALSE, 43982),

-- Puerto Rico
(6, 'San Juan', 'San Juan', 18.4655, -66.1057, TRUE, 342259),
(6, 'Bayamón', 'Bayamón', 18.3833, -66.1500, FALSE, 185187),
(6, 'Carolina', 'Carolina', 18.3809, -65.9571, FALSE, 154815),
(6, 'Ponce', 'Ponce', 18.0111, -66.6141, FALSE, 137491),

-- Trinidad and Tobago
(7, 'Port of Spain', 'Port of Spain', 10.6596, -61.5089, TRUE, 37074),
(7, 'San Fernando', 'San Fernando', 10.2796, -61.4589, FALSE, 48838),
(7, 'Chaguanas', 'Chaguanas', 10.5155, -61.4107, FALSE, 83516),
(7, 'Arima', 'Arima', 10.6372, -61.2823, FALSE, 33606),

-- Curaçao
(8, 'Willemstad', 'Willemstad', 12.1084, -68.9335, TRUE, 150000),

-- Aruba
(9, 'Oranjestad', 'Oranjestad', 12.5186, -70.0358, TRUE, 28294),

-- Barbados
(10, 'Bridgetown', 'Saint Michael', 13.0969, -59.6145, TRUE, 110000),
(10, 'Speightstown', 'Saint Peter', 13.2500, -59.6333, FALSE, 3634),
(10, 'Oistins', 'Christ Church', 13.0667, -59.5333, FALSE, 2285),

-- Saint Lucia
(11, 'Castries', 'Castries', 14.0101, -60.9875, TRUE, 20000),
(11, 'Vieux Fort', 'Vieux Fort', 13.7333, -60.9500, FALSE, 16284),
(11, 'Soufrière', 'Soufrière', 13.8500, -61.0667, FALSE, 7935),

-- Grenada
(12, 'St. George\'s', 'Saint George', 12.0561, -61.7486, TRUE, 33734),

-- Saint Vincent and the Grenadines
(13, 'Kingstown', 'Saint George', 13.1579, -61.2248, TRUE, 25418),

-- Dominica
(14, 'Roseau', 'Saint George', 15.3017, -61.3870, TRUE, 14725),

-- Antigua and Barbuda
(15, 'St. John\'s', 'Saint John', 17.1274, -61.8468, TRUE, 22219),

-- Saint Kitts and Nevis
(16, 'Basseterre', 'Saint George Basseterre', 17.2955, -62.7258, TRUE, 14725),

-- Martinique
(17, 'Fort-de-France', 'Fort-de-France', 14.6037, -61.0594, TRUE, 80041),

-- Guadeloupe
(18, 'Pointe-à-Pitre', 'Pointe-à-Pitre', 16.2333, -61.5333, FALSE, 16266),
(18, 'Basse-Terre', 'Basse-Terre', 15.9950, -61.7056, TRUE, 10058),

-- British Virgin Islands
(19, 'Road Town', 'Tortola', 18.4167, -64.6167, TRUE, 12603),

-- US Virgin Islands
(20, 'Charlotte Amalie', 'Saint Thomas', 18.3419, -64.9307, TRUE, 18481),

-- Guyana
(21, 'Georgetown', 'Demerara-Mahaica', 6.8013, -58.1551, TRUE, 118363),
(21, 'Linden', 'Upper Demerara-Berbice', 6.0081, -58.3067, FALSE, 44690),
(21, 'New Amsterdam', 'East Berbice-Corentyne', 6.2500, -57.5167, FALSE, 17329),

-- Suriname
(22, 'Paramaribo', 'Paramaribo', 5.8520, -55.2038, TRUE, 240924),
(22, 'Lelydorp', 'Wanica', 5.7053, -55.2286, FALSE, 18663),
(22, 'Nieuw Nickerie', 'Nickerie', 5.9333, -56.9833, FALSE, 12818),

-- French Guiana
(23, 'Cayenne', 'Cayenne', 4.9346, -52.3303, TRUE, 61550),
(23, 'Saint-Laurent-du-Maroni', 'Saint-Laurent-du-Maroni', 5.5000, -54.0333, FALSE, 45576),

-- Belize
(24, 'Belize City', 'Belize', 17.5045, -88.1962, FALSE, 61461),
(24, 'Belmopan', 'Cayo', 17.2510, -88.7590, TRUE, 16451),
(24, 'San Ignacio', 'Cayo', 17.1561, -89.0714, FALSE, 17878);

-- =====================================================
-- SAMPLE USERS
-- =====================================================

INSERT INTO users (id, username, email, password_hash, first_name, last_name, phone, role, status, company_name, license_number, country_id, city_id, email_verified, phone_verified) VALUES
-- Admin user
('550e8400-e29b-41d4-a716-446655440000', 'admin', 'admin@suristay.com', '$2b$12$LQv3c1yqBwlVHpPjrPyFUe.xjPeZvGcyLz4XAT.uuoiOI.yvF6YAu', 'System', 'Administrator', '+1-876-555-0001', 'admin', 'active', 'SuriStay Platform', NULL, 1, 1, TRUE, TRUE),

-- Real estate agents
('550e8400-e29b-41d4-a716-446655440001', 'marcus', 'agent.jamaica@realty.com', '$2b$12$LQv3c1yqBwlVHpPjrPyFUe.xjPeZvGcyLz4XAT.uuoiOI.yvF6YAu', 'Marcus', 'Campbell', '+1-876-555-0101', 'agent', 'active', 'Jamaica Premier Realty', 'JM-RE-2023-001', 1, 1, TRUE, TRUE),
('550e8400-e29b-41d4-a716-446655440002', 'sarah', 'sarah.bahamas@oceanview.com', '$2b$12$LQv3c1yqBwlVHpPjrPyFUe.xjPeZvGcyLz4XAT.uuoiOI.yvF6YAu', 'Sarah', 'Thompson', '+1-242-555-0102', 'agent', 'active', 'Ocean View Properties', 'BS-RE-2023-002', 2, 9, TRUE, TRUE),
('550e8400-e29b-41d4-a716-446655440003', 'carlos', 'carlos.barbados@caribbean.com', '$2b$12$LQv3c1yqBwlVHpPjrPyFUe.xjPeZvGcyLz4XAT.uuoiOI.yvF6YAu', 'Carlos', 'Rodriguez', '+1-246-555-0103', 'agent', 'active', 'Caribbean Luxury Homes', 'BB-RE-2023-003', 10, 28, TRUE, TRUE),
('550e8400-e29b-41d4-a716-446655440004', 'maria', 'maria.trinidad@tropical.com', '$2b$12$LQv3c1yqBwlVHpPjrPyFUe.xjPeZvGcyLz4XAT.uuoiOI.yvF6YAu', 'Maria', 'Singh', '+1-868-555-0104', 'agent', 'active', 'Tropical Properties Ltd', 'TT-RE-2023-004', 7, 25, TRUE, TRUE),
('550e8400-e29b-41d4-a716-446655440005', 'david', 'david.guyana@mainland.com', '$2b$12$LQv3c1yqBwlVHpPjrPyFUe.xjPeZvGcyLz4XAT.uuoiOI.yvF6YAu', 'David', 'Williams', '+592-555-0105', 'agent', 'active', 'Mainland Realty Group', 'GY-RE-2023-005', 21, 39, TRUE, TRUE),

-- Regular users
('550e8400-e29b-41d4-a716-446655440010', 'john', 'john.buyer@email.com', '$2b$12$LQv3c1yqBwlVHpPjrPyFUe.xjPeZvGcyLz4XAT.uuoiOI.yvF6YAu', 'John', 'Smith', '+1-876-555-0201', 'user', 'active', NULL, NULL, 1, 1, TRUE, FALSE),
('550e8400-e29b-41d4-a716-446655440011', 'emma', 'emma.investor@email.com', '$2b$12$LQv3c1yqBwlVHpPjrPyFUe.xjPeZvGcyLz4XAT.uuoiOI.yvF6YAu', 'Emma', 'Johnson', '+1-242-555-0202', 'user', 'active', NULL, NULL, 2, 9, TRUE, TRUE);

-- =====================================================
-- SAMPLE PROPERTIES (LOCATION-SPECIFIC)
-- =====================================================

-- JAMAICA PROPERTIES (country_id = 1)
INSERT INTO properties (
    id, user_id, title, description, property_type, listing_type, status,
    country_id, city_id, address, latitude, longitude,
    bedrooms, bathrooms, area_sqm, construction_year,
    sale_price, currency_code,
    near_beach, ocean_view, furnished, has_pool, has_garden, has_parking, gated_community, new_construction,
    contact_phone, contact_email, published_at, created_at
) VALUES
('650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'Luxury Beachfront Villa in Montego Bay', 'Stunning 4-bedroom villa with private beach access, infinity pool, and panoramic ocean views. Perfect for vacation rental or permanent residence.', 'villa', 'sale', 'active', 1, 2, 'Rose Hall, Montego Bay, Jamaica', 18.4762, -77.8939, 4, 3, 350, 2018, 1250000, 'USD', TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, '+1-876-555-0123', 'info@jamaicavillas.com', CURRENT_TIMESTAMP - INTERVAL '15 days', CURRENT_TIMESTAMP - INTERVAL '15 days'),

('650e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'Modern Apartment in Kingston', 'Contemporary 2-bedroom apartment in the heart of Kingston with city views and modern amenities.', 'apartment', 'sale', 'active', 1, 1, 'New Kingston, Kingston, Jamaica', 18.0179, -76.8099, 2, 2, 120, 2023, 185000, 'USD', FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, '+1-876-555-0124', 'sales@kingstonapts.com', CURRENT_TIMESTAMP - INTERVAL '8 days', CURRENT_TIMESTAMP - INTERVAL '8 days'),

('650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440001', 'Ocho Rios Beach House', 'Beautiful 3-bedroom beach house in Ocho Rios with direct beach access and stunning ocean views.', 'beach_house', 'sale', 'active', 1, 5, 'Main Street, Ocho Rios, Jamaica', 18.4078, -77.1031, 3, 2, 200, 2015, 750000, 'USD', TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, '+1-876-555-0125', 'beachhouse@ochorios.com', CURRENT_TIMESTAMP - INTERVAL '20 days', CURRENT_TIMESTAMP - INTERVAL '20 days'),

('650e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440001', 'Negril Sunset Villa', 'Luxury 4-bedroom villa in Negril with infinity pool, sunset views, and private chef service.', 'villa', 'sale', 'active', 1, 6, 'Seven Mile Beach, Negril, Jamaica', 18.2677, -78.3489, 4, 3, 300, 2019, 950000, 'USD', TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, '+1-876-555-0126', 'luxury@negrilsunset.com', CURRENT_TIMESTAMP - INTERVAL '12 days', CURRENT_TIMESTAMP - INTERVAL '12 days'),

('650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440001', 'Kingston Business Condo', 'Modern 1-bedroom condo in New Kingston business district, perfect for professionals.', 'condo', 'sale', 'active', 1, 1, 'Knutsford Boulevard, Kingston, Jamaica', 18.0196, -76.8103, 1, 1, 65, 2024, 120000, 'USD', FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, '+1-876-555-0127', 'business@kingstoncondo.com', CURRENT_TIMESTAMP - INTERVAL '3 days', CURRENT_TIMESTAMP - INTERVAL '3 days'),

('650e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440001', 'Port Antonio Eco Lodge', 'Sustainable 5-bedroom eco lodge in the Blue Mountains with rainforest views.', 'house', 'sale', 'active', 1, 7, 'Blue Mountain Peak Road, Port Antonio, Jamaica', 18.1747, -76.4501, 5, 4, 250, 2017, 480000, 'USD', FALSE, FALSE, TRUE, FALSE, TRUE, TRUE, FALSE, FALSE, '+1-876-555-0128', 'eco@portantonio.com', CURRENT_TIMESTAMP - INTERVAL '35 days', CURRENT_TIMESTAMP - INTERVAL '35 days');

-- BAHAMAS PROPERTIES (country_id = 2)
INSERT INTO properties (
    id, user_id, title, description, property_type, listing_type, status,
    country_id, city_id, address, latitude, longitude,
    bedrooms, bathrooms, area_sqm, construction_year,
    sale_price, currency_code,
    near_beach, ocean_view, furnished, has_pool, has_garden, has_parking, gated_community, new_construction,
    contact_phone, contact_email, published_at, created_at
) VALUES
('650e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440002', 'Paradise Island Penthouse', 'Exclusive penthouse with 360-degree ocean views, private rooftop terrace, and resort amenities.', 'penthouse', 'sale', 'active', 2, 9, 'Paradise Island, Nassau, Bahamas', 25.0834, -77.3504, 5, 4, 450, 2020, 2800000, 'USD', TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, TRUE, FALSE, '+1-242-555-0125', 'luxury@paradiseisland.com', CURRENT_TIMESTAMP - INTERVAL '22 days', CURRENT_TIMESTAMP - INTERVAL '22 days'),

('650e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440002', 'Cable Beach Condo', 'Beautiful 3-bedroom condo steps from Cable Beach with shared pool and beach access.', 'condo', 'sale', 'active', 2, 9, 'Cable Beach, Nassau, Bahamas', 25.0657, -77.4203, 3, 2, 180, 2015, 425000, 'USD', TRUE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, '+1-242-555-0126', 'info@cablebeachcondos.com', CURRENT_TIMESTAMP - INTERVAL '5 days', CURRENT_TIMESTAMP - INTERVAL '5 days'),

('650e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440002', 'Freeport Family Home', 'Spacious 4-bedroom family home in quiet Freeport neighborhood with large garden.', 'house', 'sale', 'active', 2, 10, 'Coral Gardens, Freeport, Bahamas', 26.5384, -78.6569, 4, 3, 220, 2010, 320000, 'USD', FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, '+1-242-555-0127', 'family@freeportrealty.com', CURRENT_TIMESTAMP - INTERVAL '18 days', CURRENT_TIMESTAMP - INTERVAL '18 days');

-- BARBADOS PROPERTIES (country_id = 10)
INSERT INTO properties (
    id, user_id, title, description, property_type, listing_type, status,
    country_id, city_id, address, latitude, longitude,
    bedrooms, bathrooms, area_sqm, construction_year,
    sale_price, currency_code,
    near_beach, ocean_view, furnished, has_pool, has_garden, has_parking, gated_community, new_construction,
    contact_phone, contact_email, published_at, created_at
) VALUES
('650e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440003', 'Luxury Beach House in St. Lawrence Gap', 'Magnificent beachfront house with private pool, tropical gardens, and direct beach access.', 'beach_house', 'sale', 'active', 10, 28, 'St. Lawrence Gap, Christ Church, Barbados', 13.0969, -59.6145, 6, 5, 420, 2017, 1850000, 'USD', TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, '+1-246-555-0127', 'sales@barbadosbeach.com', CURRENT_TIMESTAMP - INTERVAL '12 days', CURRENT_TIMESTAMP - INTERVAL '12 days'),

('650e8400-e29b-41d4-a716-446655440021', '550e8400-e29b-41d4-a716-446655440003', 'Chattel House Renovation Project', 'Historic Chattel house on large lot, perfect for renovation. Great investment opportunity.', 'house', 'sale', 'active', 10, 28, 'Welches, Christ Church, Barbados', 13.1132, -59.5988, 2, 1, 85, 1950, 95000, 'USD', FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, '+1-246-555-0128', 'heritage@barbadosrealty.com', CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP - INTERVAL '30 days'),

('650e8400-e29b-41d4-a716-446655440022', '550e8400-e29b-41d4-a716-446655440003', 'Modern Bridgetown Apartment', 'Contemporary 2-bedroom apartment in central Bridgetown with harbor views.', 'apartment', 'rent', 'active', 10, 28, 'Broad Street, Bridgetown, Barbados', 13.0969, -59.6145, 2, 2, 95, 2021, NULL, 'USD', FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, TRUE, '+1-246-555-0129', 'rentals@bridgetownapts.com', CURRENT_TIMESTAMP - INTERVAL '7 days', CURRENT_TIMESTAMP - INTERVAL '7 days');

-- Update rent price for the rental property
UPDATE properties SET rent_price_monthly = 1800 WHERE id = '650e8400-e29b-41d4-a716-446655440022';

-- TRINIDAD PROPERTIES (country_id = 7)
INSERT INTO properties (
    id, user_id, title, description, property_type, listing_type, status,
    country_id, city_id, address, latitude, longitude,
    bedrooms, bathrooms, area_sqm, construction_year,
    sale_price, currency_code,
    near_beach, ocean_view, furnished, has_pool, has_garden, has_parking, gated_community, new_construction,
    contact_phone, contact_email, published_at, created_at
) VALUES
('650e8400-e29b-41d4-a716-446655440030', '550e8400-e29b-41d4-a716-446655440004', 'Port of Spain Executive Townhouse', 'Modern 3-story townhouse in prestigious area with city and harbor views.', 'townhouse', 'sale', 'active', 7, 25, 'Maraval, Port of Spain, Trinidad', 10.6596, -61.5089, 4, 3, 220, 2019, 320000, 'USD', FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, '+1-868-555-0129', 'executive@trinidadrealty.com', CURRENT_TIMESTAMP - INTERVAL '18 days', CURRENT_TIMESTAMP - INTERVAL '18 days'),

('650e8400-e29b-41d4-a716-446655440031', '550e8400-e29b-41d4-a716-446655440004', 'Chaguanas Commercial Plaza', 'Prime commercial property in busy Chaguanas with multiple retail units.', 'commercial', 'sale', 'active', 7, 27, 'Main Road, Chaguanas, Trinidad', 10.5155, -61.4107, 0, 4, 800, 2016, 850000, 'USD', FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, '+1-868-555-0130', 'commercial@trinidadproperties.com', CURRENT_TIMESTAMP - INTERVAL '25 days', CURRENT_TIMESTAMP - INTERVAL '25 days');

-- GUYANA PROPERTIES (country_id = 21)
INSERT INTO properties (
    id, user_id, title, description, property_type, listing_type, status,
    country_id, city_id, address, latitude, longitude,
    bedrooms, bathrooms, area_sqm, construction_year,
    sale_price, currency_code,
    near_beach, ocean_view, furnished, has_pool, has_garden, has_parking, gated_community, new_construction,
    contact_phone, contact_email, published_at, created_at
) VALUES
('650e8400-e29b-41d4-a716-446655440040', '550e8400-e29b-41d4-a716-446655440005', 'Georgetown Colonial Mansion', 'Restored colonial mansion with original features, large grounds, and modern updates.', 'house', 'sale', 'active', 21, 39, 'Brickdam, Georgetown, Guyana', 6.8013, -58.1551, 8, 6, 650, 1890, 450000, 'USD', FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, '+592-555-0130', 'colonial@guyanaproperties.com', CURRENT_TIMESTAMP - INTERVAL '25 days', CURRENT_TIMESTAMP - INTERVAL '25 days'),

('650e8400-e29b-41d4-a716-446655440041', '550e8400-e29b-41d4-a716-446655440005', 'Linden Riverside Home', 'Modern 3-bedroom home overlooking the Demerara River with boat dock.', 'house', 'sale', 'active', 21, 40, 'Riverside Drive, Linden, Guyana', 6.0081, -58.3067, 3, 2, 180, 2020, 185000, 'USD', FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE, TRUE, '+592-555-0131', 'riverside@lindenrealty.com', CURRENT_TIMESTAMP - INTERVAL '14 days', CURRENT_TIMESTAMP - INTERVAL '14 days');

-- SURINAME PROPERTIES (country_id = 22)
INSERT INTO properties (
    id, user_id, title, description, property_type, listing_type, status,
    country_id, city_id, address, latitude, longitude,
    bedrooms, bathrooms, area_sqm, construction_year,
    sale_price, currency_code,
    near_beach, ocean_view, furnished, has_pool, has_garden, has_parking, gated_community, new_construction,
    contact_phone, contact_email, published_at, created_at
) VALUES
('650e8400-e29b-41d4-a716-446655440050', '550e8400-e29b-41d4-a716-446655440005', 'Paramaribo Riverside Apartment', 'Modern apartment overlooking the Suriname River with balcony and river views.', 'apartment', 'sale', 'active', 22, 42, 'Waterkant, Paramaribo, Suriname', 5.8520, -55.2038, 2, 1, 95, 2022, 125000, 'USD', FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, TRUE, '+597-555-0131', 'riverside@surinameapts.com', CURRENT_TIMESTAMP - INTERVAL '7 days', CURRENT_TIMESTAMP - INTERVAL '7 days');

-- =====================================================
-- PROPERTY IMAGES
-- =====================================================

INSERT INTO property_images (id, property_id, image_url, thumbnail_url, alt_text, display_order, is_primary) VALUES
-- Jamaica properties
('750e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800', 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=300', 'Luxury villa exterior with pool', 0, TRUE),
('750e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440001', 'https://images.unsplash.com/photo-1582268611958-ebfd161ef9cf?w=800', 'https://images.unsplash.com/photo-1582268611958-ebfd161ef9cf?w=300', 'Villa interior living room', 1, FALSE),
('750e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440002', 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800', 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=300', 'Modern apartment exterior', 0, TRUE),
('750e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440003', 'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=800', 'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=300', 'Beach house with ocean view', 0, TRUE),
('750e8400-e29b-41d4-a716-446655440005', '650e8400-e29b-41d4-a716-446655440004', 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800', 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=300', 'Sunset villa with infinity pool', 0, TRUE),
('750e8400-e29b-41d4-a716-446655440006', '650e8400-e29b-41d4-a716-446655440005', 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800', 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=300', 'Business condo building', 0, TRUE),
('750e8400-e29b-41d4-a716-446655440007', '650e8400-e29b-41d4-a716-446655440006', 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800', 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=300', 'Eco lodge in mountains', 0, TRUE),

-- Bahamas properties
('750e8400-e29b-41d4-a716-446655440010', '650e8400-e29b-41d4-a716-446655440010', 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800', 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=300', 'Paradise Island penthouse', 0, TRUE),
('750e8400-e29b-41d4-a716-446655440011', '650e8400-e29b-41d4-a716-446655440011', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=300', 'Cable Beach condo', 0, TRUE),
('750e8400-e29b-41d4-a716-446655440012', '650e8400-e29b-41d4-a716-446655440012', 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800', 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=300', 'Freeport family home', 0, TRUE),

-- Barbados properties
('750e8400-e29b-41d4-a716-446655440020', '650e8400-e29b-41d4-a716-446655440020', 'https://images.unsplash.com/photo-1520637836862-4d197d17c90a?w=800', 'https://images.unsplash.com/photo-1520637836862-4d197d17c90a?w=300', 'Luxury beach house Barbados', 0, TRUE),
('750e8400-e29b-41d4-a716-446655440021', '650e8400-e29b-41d4-a716-446655440021', 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=800', 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=300', 'Historic chattel house', 0, TRUE),
('750e8400-e29b-41d4-a716-446655440022', '650e8400-e29b-41d4-a716-446655440022', 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800', 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=300', 'Modern Bridgetown apartment', 0, TRUE);

-- =====================================================
-- PROPERTY AMENITIES
-- =====================================================

INSERT INTO property_amenities (property_id, amenity_name, amenity_category, description) VALUES
-- Jamaica villa amenities
('650e8400-e29b-41d4-a716-446655440001', 'Private Beach Access', 'exterior', 'Direct access to private beach area'),
('650e8400-e29b-41d4-a716-446655440001', 'Infinity Pool', 'exterior', 'Heated infinity pool with ocean views'),
('650e8400-e29b-41d4-a716-446655440001', 'Chef Kitchen', 'interior', 'Professional grade kitchen with island'),
('650e8400-e29b-41d4-a716-446655440001', 'Wine Cellar', 'interior', 'Climate controlled wine storage'),

-- Bahamas penthouse amenities
('650e8400-e29b-41d4-a716-446655440010', 'Rooftop Terrace', 'exterior', 'Private rooftop with 360-degree views'),
('650e8400-e29b-41d4-a716-446655440010', 'Concierge Service', 'community', '24/7 concierge and valet services'),
('650e8400-e29b-41d4-a716-446655440010', 'Resort Access', 'community', 'Full access to resort amenities'),

-- Barbados beach house amenities
('650e8400-e29b-41d4-a716-446655440020', 'Outdoor Kitchen', 'exterior', 'Fully equipped outdoor cooking area'),
('650e8400-e29b-41d4-a716-446655440020', 'Tropical Gardens', 'exterior', 'Landscaped gardens with native plants'),
('650e8400-e29b-41d4-a716-446655440020', 'Beach Cabana', 'exterior', 'Private cabana on the beach');

-- =====================================================
-- SYSTEM SETTINGS
-- =====================================================

INSERT INTO system_settings (key, value, description) VALUES
('site_name', 'SuriStay Caribbean Real Estate', 'Platform name'),
('default_currency', 'USD', 'Default currency for listings'),
('max_images_per_property', '20', 'Maximum number of images per property'),
('featured_listing_duration_days', '30', 'Duration for featured listings'),
('property_expiry_days', '365', 'Default property listing expiry period'),
('min_property_price', '1000', 'Minimum property price in USD'),
('max_property_price', '50000000', 'Maximum property price in USD'),
('enable_email_notifications', 'true', 'Enable email notifications'),
('enable_sms_notifications', 'false', 'Enable SMS notifications'),
('maintenance_mode', 'false', 'Site maintenance mode');

-- =====================================================
-- SAMPLE USER FAVORITES
-- =====================================================

INSERT INTO user_favorites (user_id, property_id) VALUES
('550e8400-e29b-41d4-a716-446655440010', '650e8400-e29b-41d4-a716-446655440001'), -- John likes Jamaica villa
('550e8400-e29b-41d4-a716-446655440010', '650e8400-e29b-41d4-a716-446655440003'), -- John likes Ocho Rios beach house
('550e8400-e29b-41d4-a716-446655440011', '650e8400-e29b-41d4-a716-446655440010'), -- Emma likes Bahamas penthouse
('550e8400-e29b-41d4-a716-446655440011', '650e8400-e29b-41d4-a716-446655440020'); -- Emma likes Barbados beach house

-- =====================================================
-- SAMPLE PROPERTY INQUIRIES
-- =====================================================

INSERT INTO property_inquiries (property_id, user_id, name, email, phone, message, inquiry_type) VALUES
('650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440010', 'John Smith', 'john.buyer@email.com', '+1-876-555-0201', 'I am interested in viewing this beautiful villa. When would be a good time to schedule a visit?', 'viewing'),
('650e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440011', 'Emma Johnson', 'emma.investor@email.com', '+1-242-555-0202', 'This penthouse looks amazing! Could you provide more details about the HOA fees and resort amenities?', 'general'),
('650e8400-e29b-41d4-a716-446655440003', NULL, 'Michael Brown', 'michael.brown@email.com', '+1-876-555-0301', 'Is this beach house available for vacation rental? What are the weekly rates?', 'general');

-- =====================================================
-- SAMPLE SAVED SEARCHES
-- =====================================================

INSERT INTO saved_searches (user_id, name, search_criteria, email_alerts) VALUES
('550e8400-e29b-41d4-a716-446655440010', 'Jamaica Beachfront Properties', '{"country": "Jamaica", "near_beach": true, "max_price": 1000000, "min_bedrooms": 3}', TRUE),
('550e8400-e29b-41d4-a716-446655440011', 'Luxury Caribbean Villas', '{"property_type": "villa", "min_price": 500000, "has_pool": true, "ocean_view": true}', TRUE);

-- =====================================================
-- COMPLETION MESSAGE
-- =====================================================

-- Display summary of inserted data
DO $$
DECLARE
    country_count INTEGER;
    city_count INTEGER;
    user_count INTEGER;
    property_count INTEGER;
    image_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO country_count FROM countries;
    SELECT COUNT(*) INTO city_count FROM cities;
    SELECT COUNT(*) INTO user_count FROM users;
    SELECT COUNT(*) INTO property_count FROM properties;
    SELECT COUNT(*) INTO image_count FROM property_images;
    
    RAISE NOTICE '=== CARIBBEAN REAL ESTATE DATABASE INITIALIZED ===';
    RAISE NOTICE 'Countries: %', country_count;
    RAISE NOTICE 'Cities: %', city_count;
    RAISE NOTICE 'Users: %', user_count;
    RAISE NOTICE 'Properties: %', property_count;
    RAISE NOTICE 'Property Images: %', image_count;
    RAISE NOTICE '=== LOCATION-SPECIFIC DATA LOADED ===';
    RAISE NOTICE 'Jamaica properties: 6 (only in Jamaica cities)';
    RAISE NOTICE 'Bahamas properties: 3 (only in Bahamas cities)';
    RAISE NOTICE 'Barbados properties: 3 (only in Barbados cities)';
    RAISE NOTICE 'Trinidad properties: 2 (only in Trinidad cities)';
    RAISE NOTICE 'Guyana properties: 2 (only in Guyana cities)';
    RAISE NOTICE 'Suriname properties: 1 (only in Suriname cities)';
    RAISE NOTICE '=== DATABASE READY FOR USE ===';
END $$;
