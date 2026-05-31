
## Welcome to Sunda real estate app.

Om het te starten heb je 3 onderdelen nodig:

1. in een cmd moet je de node server opstarten. dat is in deze directory: 

C:.....\houzi-1.4.4.1_valid\houzi-1.4.4.1\api_server> 

Vervolgens doe je ''node server.js'' en enter.

2. Een android emulator. ik gebruik android studio met de volgende instellingen voor mijn emulator: 
    Pixel 7 Pro, Android 13, Tiramisu API 33 en de Google play intel x86_64 Atom system image

3. Installatie & Setup (eenmalig):
   
   **Node.js dependencies installeren:**
   ```
   cd api_server
   npm install
   ```

   **Flutter dependencies installeren:**
   ```
   flutter pub get
   ```

   **PostgreSQL database setup:**
   - Start PostgreSQL
   - Run: `database/setup.sql` om de database te maken


   **App starten:**
   ```
   flutter run -d emulator-5554 (of je eigen emulator naam)
   ```



   **API server starten:**
   ```
   cd api_server
   node server.js

Waar te bewerken:

- thema:
  - `lib/constants/suristay_colors.dart` line 8 — `class SuriStayColors`
- inlog:
  - `lib/pages/agency_login_page.dart` line 16 — `class AgencyLoginPage`
  - `lib/hooks_v2.dart` line 754-767 — redirect van Houzi login naar Agency Login
- properties toevoegen:
  - `packages/houzi_package/lib/pages/quick_add_property/quick_add_property_v2.dart` line 25 — `class QuickAddPropertyV2`
  - `packages/houzi_package/lib/files/property_manager_files/property_manager.dart` line 432 — `uploadProperty()`
  - `lib/services/postgresql_property_service.dart` line 35 — `uploadProperty(...)`
- database:
  - `api_server/server.js` line 525 — `app.post('/api/properties'`
  - `database/setup.sql` — database schema en sample data
- OpenStreetView:
  - `packages/houzi_package/lib/widgets/openstreet_caribbean_map.dart` line 6 — `class OpenStreetCaribbeanMap`
- tests:
  - `explanation/tests/simple_property_tests.dart` line 24 — `testPriceExtraction()` en overige testfuncties
- caricom main page:
  - `lib/caricom_region_main_page.dart` line 12 — `class CaricomRegionMainPage`


