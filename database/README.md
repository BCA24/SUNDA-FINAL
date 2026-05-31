# Caribbean Real Estate Platform Database

## Overview

This PostgreSQL database is designed for a comprehensive Caribbean real estate platform where users can list and search for properties across the Caribbean region. The database ensures **location-specific data integrity** - properties in Jamaica only appear when searching Jamaica, properties in Bahamas only appear when searching Bahamas, etc.

## Key Features

- **Location-Specific Properties**: Properties are strictly tied to their actual locations
- **Full User Management**: Complete user system with roles (admin, agent, user, moderator)
- **Advanced Filtering**: Support for all property filter criteria from the Flutter app
- **Analytics & Tracking**: Property views, inquiries, and search analytics
- **Image Management**: Multiple images per property with primary image support
- **Favorites & Saved Searches**: User engagement features
- **Multi-Currency Support**: Different currencies for different countries

## Database Structure

### Core Tables

1. **countries** - Caribbean countries and territories (25 countries)
2. **cities** - Cities within each country (47+ major cities)
3. **users** - Platform users with role-based access
4. **properties** - Main property listings with all filterable attributes
5. **property_images** - Property photos and media
6. **property_amenities** - Additional property features

### Support Tables

- **user_favorites** - User saved properties
- **property_inquiries** - Contact inquiries for properties
- **saved_searches** - User saved search criteria with alerts
- **property_views** - Analytics tracking
- **user_sessions** - Authentication management

## Location Hierarchy

```
Region (West/East/Mainland)
├── Countries (Jamaica, Bahamas, Barbados, etc.)
    ├── Cities (Kingston, Nassau, Bridgetown, etc.)
        └── Properties (specific to that city/country)
```

### Regional Distribution

- **West Region**: Jamaica, Bahamas, Cuba, Haiti, Dominican Republic, Puerto Rico, Trinidad & Tobago, Curaçao, Aruba
- **East Region**: Barbados, Saint Lucia, Grenada, Antigua & Barbuda, etc.
- **Mainland Region**: Guyana, Suriname, French Guiana, Belize

## Sample Data

The database includes comprehensive sample data:

- **25 Countries** with proper regional classification
- **47+ Cities** across all countries
- **8 Users** (1 admin, 5 agents, 2 regular users)
- **17 Properties** distributed across 6 countries:
  - Jamaica: 6 properties (villas, apartments, beach houses)
  - Bahamas: 3 properties (penthouse, condo, family home)
  - Barbados: 3 properties (beach house, historic home, apartment)
  - Trinidad: 2 properties (townhouse, commercial)
  - Guyana: 2 properties (colonial mansion, riverside home)
  - Suriname: 1 property (riverside apartment)

## Setup Instructions

### 1. Create Database

```sql
-- Connect to PostgreSQL as superuser
CREATE DATABASE caribbean_real_estate;
CREATE USER caribbean_user WITH PASSWORD 'your_secure_password';
GRANT ALL PRIVILEGES ON DATABASE caribbean_real_estate TO caribbean_user;
```

### 2. Initialize Schema

```bash
# Run the schema creation script
psql -U caribbean_user -d caribbean_real_estate -f database/schema.sql
```

### 3. Load Sample Data

```bash
# Load sample data
psql -U caribbean_user -d caribbean_real_estate -f database/sample_data.sql
```

## Key Database Features

### 1. Location-Specific Filtering

Properties are strictly tied to their locations through foreign key relationships:

```sql
-- Get properties only in Jamaica
SELECT p.*, c.name as country_name, ct.name as city_name 
FROM properties p
JOIN countries c ON p.country_id = c.id
JOIN cities ct ON p.city_id = ct.id
WHERE c.code = 'JAM' AND p.status = 'active';
```

### 2. Advanced Property Filtering

The database supports all filter criteria from the Flutter app:

```sql
-- Example: Find beachfront villas in West region under $1M
SELECT p.*, c.name as country_name, ct.name as city_name
FROM property_search_view p
JOIN countries c ON p.country_code = c.code
WHERE c.region = 'West'
  AND p.property_type = 'villa'
  AND p.near_beach = TRUE
  AND p.sale_price <= 1000000
  AND p.sale_price > 0
ORDER BY p.sale_price DESC;
```

### 3. User Role Management

```sql
-- Get all active real estate agents
SELECT u.*, c.name as country_name, ct.name as city_name
FROM users u
LEFT JOIN countries c ON u.country_id = c.id
LEFT JOIN cities ct ON u.city_id = ct.id
WHERE u.role = 'agent' AND u.status = 'active';
```

### 4. Analytics Queries

```sql
-- Property performance analytics
SELECT 
    p.title,
    p.view_count,
    p.inquiry_count,
    p.favorite_count,
    c.name as country_name
FROM properties p
JOIN countries c ON p.country_id = c.id
WHERE p.status = 'active'
ORDER BY p.view_count DESC
LIMIT 10;
```

## Useful Queries

### Property Search by Region

```sql
-- Get all active properties in West region
SELECT p.*, c.name as country_name, ct.name as city_name
FROM active_properties_view p
JOIN countries c ON p.country_id = c.id
JOIN cities ct ON p.city_id = ct.id
WHERE c.region = 'West'
ORDER BY p.published_at DESC;
```

### Filter Properties by Multiple Criteria

```sql
-- Advanced filtering example
SELECT *
FROM property_search_view
WHERE country_code = 'JAM'  -- Jamaica only
  AND bedrooms >= 3
  AND sale_price BETWEEN 200000 AND 800000
  AND near_beach = TRUE
  AND has_pool = TRUE
ORDER BY sale_price ASC;
```

### User Activity Report

```sql
-- User engagement report
SELECT 
    u.first_name || ' ' || u.last_name as user_name,
    u.email,
    COUNT(DISTINCT f.property_id) as favorites_count,
    COUNT(DISTINCT i.id) as inquiries_count,
    COUNT(DISTINCT s.id) as saved_searches_count
FROM users u
LEFT JOIN user_favorites f ON u.id = f.user_id
LEFT JOIN property_inquiries i ON u.id = i.user_id
LEFT JOIN saved_searches s ON u.id = s.user_id
WHERE u.role = 'user'
GROUP BY u.id, u.first_name, u.last_name, u.email
ORDER BY favorites_count DESC;
```

### Property Listing by Agent

```sql
-- Get all properties listed by a specific agent
SELECT 
    p.title,
    p.property_type,
    p.sale_price,
    p.status,
    c.name as country_name,
    ct.name as city_name,
    p.created_at
FROM properties p
JOIN countries c ON p.country_id = c.id
JOIN cities ct ON p.city_id = ct.id
JOIN users u ON p.user_id = u.id
WHERE u.email = 'agent.jamaica@realty.com'
ORDER BY p.created_at DESC;
```

## Performance Considerations

### Indexes

The database includes comprehensive indexes for:
- Location-based searches (country_id, city_id)
- Property filtering (price, bedrooms, bathrooms, property_type)
- Boolean feature filters (near_beach, has_pool, etc.)
- Full-text search on titles and descriptions
- Geographic coordinates for map-based searches

### Views

Pre-built views for common queries:
- `active_properties_view` - Active properties with location info
- `property_search_view` - Optimized for search and filtering

## Security Features

- UUID primary keys for users and properties
- Password hashing with bcrypt
- Session management with expiration
- Email verification system
- Role-based access control
- Input validation through database constraints

## Maintenance

### Regular Tasks

1. **Clean expired sessions**:
```sql
DELETE FROM user_sessions WHERE expires_at < CURRENT_TIMESTAMP;
```

2. **Update property statistics**:
```sql
-- Statistics are automatically updated via triggers
-- Manual refresh if needed:
REFRESH MATERIALIZED VIEW IF EXISTS property_stats_view;
```

3. **Archive old property views**:
```sql
-- Archive views older than 1 year
DELETE FROM property_views WHERE viewed_at < CURRENT_TIMESTAMP - INTERVAL '1 year';
```

## Integration with Flutter App

The database is designed to work seamlessly with the existing Flutter property filter system:

1. **Filter Mapping**: All filter criteria from `PropertyFilterCriteria` class map directly to database columns
2. **Location Filtering**: Properties are automatically filtered by country/region
3. **Real-time Updates**: Database triggers maintain accurate counts and statistics
4. **Image Support**: Primary images and thumbnails are properly managed

## Next Steps

1. **API Development**: Create REST API endpoints for Flutter app integration
2. **Authentication**: Implement JWT-based authentication
3. **File Upload**: Set up image upload and storage system
4. **Notifications**: Implement email alerts for saved searches
5. **Backup Strategy**: Set up automated database backups
6. **Monitoring**: Add database performance monitoring

## Connection Details

```
Database: caribbean_real_estate
User: caribbean_user
Host: localhost (or your server)
Port: 5432 (default PostgreSQL port)
```

## Support

For database-related questions or issues:
1. Check the query examples above
2. Review the schema documentation in `schema.sql`
3. Examine sample data in `sample_data.sql`
4. Test queries using the provided examples
