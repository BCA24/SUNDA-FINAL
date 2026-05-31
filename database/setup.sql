-- =====================================================
-- CARIBBEAN REAL ESTATE DATABASE QUICK SETUP
-- Run this script to create database and user
-- =====================================================

-- This script should be run as PostgreSQL superuser (postgres)
-- Usage: psql -U postgres -f database/setup.sql

-- Create database
CREATE DATABASE caribbean_real_estate
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    TEMPLATE = template0
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

-- Create user
CREATE USER caribbean_user WITH
    LOGIN
    NOSUPERUSER
    CREATEDB
    NOCREATEROLE
    INHERIT
    NOREPLICATION
    CONNECTION LIMIT -1
    PASSWORD 'caribbean_secure_2024!';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE caribbean_real_estate TO caribbean_user;

-- Connect to the new database
\c caribbean_real_estate

-- Grant schema privileges
GRANT ALL ON SCHEMA public TO caribbean_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO caribbean_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO caribbean_user;

-- Set default privileges for future objects
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO caribbean_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO caribbean_user;

\echo '=== DATABASE SETUP COMPLETE ==='
\echo 'Database: caribbean_real_estate'
\echo 'User: caribbean_user'
\echo 'Password: caribbean_secure_2024!'
\echo ''
\echo 'Next steps:'
\echo '1. Run: psql -U caribbean_user -d caribbean_real_estate -f database/schema.sql'
\echo '2. Run: psql -U caribbean_user -d caribbean_real_estate -f database/sample_data.sql'
\echo '3. Test connection: psql -U caribbean_user -d caribbean_real_estate'
