-- =====================================================
-- CARIBBEAN REAL ESTATE DATABASE - CONNECTION TEST
-- Quick test to verify database is working properly
-- =====================================================

-- Usage: psql -U caribbean_user -d caribbean_real_estate -f database/connection_test.sql

\echo '=== CARIBBEAN REAL ESTATE DATABASE CONNECTION TEST ==='
\echo ''

-- Test 1: Database Connection
\echo 'Test 1: Database Connection'
SELECT 
    current_database() as database_name,
    current_user as connected_user,
    version() as postgresql_version;

\echo ''

-- Test 2: Tables Exist
\echo 'Test 2: Checking if all tables exist'
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

\echo ''

-- Test 3: Sample Data Loaded
\echo 'Test 3: Checking sample data'
SELECT 
    'Countries' as data_type,
    COUNT(*) as count
FROM countries

UNION ALL

SELECT 
    'Cities' as data_type,
    COUNT(*) as count
FROM cities

UNION ALL

SELECT 
    'Users' as data_type,
    COUNT(*) as count
FROM users

UNION ALL

SELECT 
    'Properties' as data_type,
    COUNT(*) as count
FROM properties

UNION ALL

SELECT 
    'Property Images' as data_type,
    COUNT(*) as count
FROM property_images;

\echo ''

-- Test 4: Location-Specific Data
\echo 'Test 4: Properties by Country (Location-Specific Test)'
SELECT 
    c.name as country,
    c.region,
    COUNT(p.id) as property_count
FROM countries c
LEFT JOIN properties p ON c.id = p.country_id AND p.status = 'active'
GROUP BY c.id, c.name, c.region
HAVING COUNT(p.id) > 0
ORDER BY property_count DESC;

\echo ''

-- Test 5: Filter Functionality
\echo 'Test 5: Filter Test - Jamaica Properties Under $500K'
SELECT 
    title,
    sale_price,
    bedrooms,
    bathrooms,
    country_name,
    city_name
FROM property_search_view
WHERE country_code = 'JAM'
  AND sale_price <= 500000
  AND sale_price > 0
ORDER BY sale_price ASC
LIMIT 5;

\echo ''

-- Test 6: User System
\echo 'Test 6: User System Test'
SELECT 
    role,
    status,
    COUNT(*) as user_count
FROM users
GROUP BY role, status
ORDER BY role, status;

\echo ''

-- Test 7: Database Performance
\echo 'Test 7: Index Usage Check'
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan as times_used
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
  AND idx_scan > 0
ORDER BY idx_scan DESC
LIMIT 10;

\echo ''

-- Test 8: Views Working
\echo 'Test 8: Database Views Test'
SELECT 
    table_name as view_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'VIEW'
ORDER BY table_name;

\echo ''

-- Test 9: Triggers Working
\echo 'Test 9: Trigger Test (Property View Count)'
-- This should show properties with view counts > 0 if triggers are working
SELECT 
    title,
    view_count,
    inquiry_count,
    favorite_count
FROM properties
WHERE view_count > 0 OR inquiry_count > 0 OR favorite_count > 0
ORDER BY view_count DESC
LIMIT 5;

\echo ''

-- Test 10: Foreign Key Relationships
\echo 'Test 10: Foreign Key Relationship Test'
SELECT 
    p.title,
    c.name as country,
    ct.name as city,
    u.first_name || ' ' || u.last_name as owner
FROM properties p
JOIN countries c ON p.country_id = c.id
JOIN cities ct ON p.city_id = ct.id
JOIN users u ON p.user_id = u.id
WHERE p.status = 'active'
ORDER BY p.created_at DESC
LIMIT 3;

\echo ''

-- Final Status Check
DO $$
DECLARE
    country_count INTEGER;
    city_count INTEGER;
    user_count INTEGER;
    property_count INTEGER;
    active_property_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO country_count FROM countries;
    SELECT COUNT(*) INTO city_count FROM cities;
    SELECT COUNT(*) INTO user_count FROM users WHERE status = 'active';
    SELECT COUNT(*) INTO property_count FROM properties;
    SELECT COUNT(*) INTO active_property_count FROM properties WHERE status = 'active';
    
    RAISE NOTICE '';
    RAISE NOTICE '=== DATABASE STATUS SUMMARY ===';
    RAISE NOTICE 'Countries: %', country_count;
    RAISE NOTICE 'Cities: %', city_count;
    RAISE NOTICE 'Active Users: %', user_count;
    RAISE NOTICE 'Total Properties: %', property_count;
    RAISE NOTICE 'Active Properties: %', active_property_count;
    RAISE NOTICE '';
    
    IF country_count >= 25 AND city_count >= 40 AND user_count >= 5 AND active_property_count >= 10 THEN
        RAISE NOTICE '✅ DATABASE CONNECTION TEST: PASSED';
        RAISE NOTICE '✅ All systems operational!';
        RAISE NOTICE '';
        RAISE NOTICE 'Ready for:';
        RAISE NOTICE '• User registration and login';
        RAISE NOTICE '• Property posting and management';
        RAISE NOTICE '• Location-specific property filtering';
        RAISE NOTICE '• Advanced search and filtering';
        RAISE NOTICE '• User interactions and analytics';
    ELSE
        RAISE NOTICE '❌ DATABASE CONNECTION TEST: FAILED';
        RAISE NOTICE 'Some data may be missing. Please run sample_data.sql';
    END IF;
    
    RAISE NOTICE '';
    RAISE NOTICE 'Next steps:';
    RAISE NOTICE '1. Run: psql -U caribbean_user -d caribbean_real_estate -f database/test_user_workflow.sql';
    RAISE NOTICE '2. Create API endpoints for Flutter integration';
    RAISE NOTICE '3. Implement user authentication in your app';
    RAISE NOTICE '';
END $$;
