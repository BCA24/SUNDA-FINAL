@echo off
echo ================================================
echo   Caribbean Real Estate Database Setup
echo ================================================
echo.

REM Set your PostgreSQL bin path (adjust version if needed)
set PGBIN=D:\PostgreSQL\bin
if exist "%PGBIN%\psql.exe" (
    set PATH=%PGBIN%;%PATH%
) else (
    echo ERROR: PostgreSQL not found at D:\PostgreSQL\bin
    echo Please adjust PGBIN variable in this script to your PostgreSQL bin path.
    echo.
    pause
    exit /b 1
)

REM Check if psql is accessible
psql --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: psql command not found.
    echo Please install PostgreSQL or add it to your PATH.
    echo.
    pause
    exit /b 1
)

echo PostgreSQL found: %PGBIN%
echo.

REM Prompt for postgres password
echo Please enter your PostgreSQL 'postgres' user password:
echo (This is the password you set during PostgreSQL installation)
echo.
set /p PGPASS=Password: 

REM Set password for this session
set PGPASSWORD=%PGPASS%

echo.
echo ================================================
echo   Step 1: Creating database and user...
echo ================================================
psql -U postgres -f setup.sql

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ================================================
    echo   ERROR: Failed to create database
    echo ================================================
    echo.
    echo Possible reasons:
    echo 1. Incorrect password - Please check your PostgreSQL password
    echo 2. PostgreSQL service not running - Start it from services.msc
    echo 3. PostgreSQL not properly installed
    echo.
    echo See WINDOWS_SETUP_GUIDE.md for detailed troubleshooting.
    echo.
    pause
    exit /b 1
)

REM Update password for caribbean_user
set PGPASSWORD=caribbean_secure_2024!

echo.
echo ================================================
echo   Step 2: Creating schema (tables, views, etc)...
echo ================================================
psql -U caribbean_user -d caribbean_real_estate -f schema.sql

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to create schema.
    echo The database was created but schema setup failed.
    echo.
    pause
    exit /b 1
)

echo.
echo ================================================
echo   Step 3: Loading sample data...
echo ================================================
psql -U caribbean_user -d caribbean_real_estate -f sample_data.sql

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to load sample data.
    echo.
    pause
    exit /b 1
)

echo.
echo ================================================
echo   Step 4: Running connection test...
echo ================================================
psql -U caribbean_user -d caribbean_real_estate -f connection_test.sql

echo.
echo ================================================
echo   ✅ Database Setup Complete!
echo ================================================
echo.
echo Database Name: caribbean_real_estate
echo Database User: caribbean_user
echo Database Password: caribbean_secure_2024!
echo.
echo 📊 Your database now contains:
echo    • 25 Caribbean countries
echo    • 47+ major cities
echo    • 17 sample properties
echo    • 8 sample users
echo    • Complete schema with filtering support
echo.
echo ================================================
echo   🚀 Next Steps:
echo ================================================
echo.
echo 1. Start the API Server:
echo    cd ..\api_server
echo    npm install
echo    npm start
echo.
echo 2. Test the API:
echo    curl http://localhost:3000/api/health
echo    curl http://localhost:3000/api/test/db
echo.
echo 3. Run your Flutter app:
echo    cd ..
echo    flutter run
echo.
echo 4. Follow FRONTEND_TESTING_GUIDE.md to test:
echo    • User registration and login
echo    • Property posting
echo    • Location-specific filtering
echo.
echo ================================================
echo   📚 Documentation:
echo ================================================
echo    • WINDOWS_SETUP_GUIDE.md - Troubleshooting help
echo    • TESTING_GUIDE.md - Database testing
echo    • FRONTEND_TESTING_GUIDE.md - Flutter app testing
echo    • README.md - Complete database documentation
echo.
pause
