@echo off
echo ========================================
echo COMPLETE DATABASE FIX
echo ========================================
echo.
echo This will:
echo 1. Create simple_users table for agency login
echo 2. Load ALL sample data (countries, cities, properties)
echo 3. Verify database is ready
echo.
pause

echo.
echo [1/3] Creating simple_users table...
psql -U caribbean_user -d caribbean_real_estate -f add_simple_users_table.sql

echo.
echo [2/3] Loading sample data...
psql -U caribbean_user -d caribbean_real_estate -f sample_data.sql

echo.
echo [3/3] Verifying data...
psql -U caribbean_user -d caribbean_real_estate -c "SELECT COUNT(*) as total_countries FROM countries;"
psql -U caribbean_user -d caribbean_real_estate -c "SELECT COUNT(*) as total_properties FROM properties;"
psql -U caribbean_user -d caribbean_real_estate -c "SELECT COUNT(*) as total_agencies FROM simple_users WHERE role='agency';"

echo.
echo ========================================
echo DATABASE FIX COMPLETE!
echo ========================================
echo.
echo You can now:
echo 1. Login with: agency@suristay.com / agency123
echo 2. See properties in Jamaica, Bahamas, Barbados, etc.
echo.
echo IMPORTANT: Restart your Node.js server now!
echo   cd api_server
echo   node server.js
echo.
pause
