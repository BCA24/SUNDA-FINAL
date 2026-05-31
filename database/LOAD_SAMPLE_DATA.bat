@echo off
echo ========================================
echo Loading Sample Data into Database
echo ========================================
echo.

echo Loading sample data (properties, countries, cities, users)...
psql -U caribbean_user -d caribbean_real_estate -f sample_data.sql

echo.
echo ========================================
echo Sample Data Loading Complete!
echo ========================================
echo.
echo You should now have:
echo - 24 Caribbean countries
echo - Sample cities in each country
echo - Sample properties in Jamaica, Bahamas, Barbados, etc.
echo - Sample users and agents
echo.
pause
