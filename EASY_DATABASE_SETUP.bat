@echo off
echo ========================================
echo   Caribbean Real Estate Database Setup
echo ========================================
echo.
echo This will create the database and all tables.
echo.
pause

echo.
echo Step 1: Creating database...
psql -U postgres -c "CREATE DATABASE caribbean_real_estate;"
psql -U postgres -c "CREATE USER caribbean_user WITH PASSWORD 'caribbean_secure_2024!';"
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE caribbean_real_estate TO caribbean_user;"

echo.
echo Step 2: Creating tables...
cd database
psql -U postgres -d caribbean_real_estate -f schema.sql

echo.
echo Step 3: Adding sample data (optional)...
psql -U postgres -d caribbean_real_estate -f sample_data.sql

echo.
echo ========================================
echo   DONE! Database is ready!
echo ========================================
echo.
echo Now:
echo 1. Start API server: cd api_server && node server.js
echo 2. Test registration in your app!
echo.
pause
