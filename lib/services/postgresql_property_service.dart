import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/common/constants.dart';

/// PostgreSQL Property Service
/// 
/// This service handles uploading property listings to the PostgreSQL backend.
/// It converts Houzi framework format (prop_*, fave_*) to the PostgreSQL API format.
/// 
/// HOUZI FIELD NAME CONVENTIONS:
/// - prop_* : Abbreviated field names from quick property add forms (e.g., prop_beds = bedrooms)
/// - fave_* : Full property fields (e.g., fave_property_bedrooms = detailed property bedrooms)
/// - Mapping: {prop_beds → bedrooms, prop_baths → bathrooms, prop_size → area_sqm, etc.}
/// 
/// DATABASE STORAGE:
/// - Converts shorthand form data to PostgreSQL properties table format
/// - Default owner: admin UUID (550e8400-e29b-41d4-a716-446655440000) if user not logged in
/// - Handles multi-unit properties with floor plans via floor_plans[] array
class PostgreSQLPropertyService {
  // Android emulator uses special IP 10.0.2.2 to access host machine's localhost
  // For physical devices on same network, update to: http://172.16.100.201:3000/api
  static const String API_BASE_URL = 'http://10.0.2.2:3000/api';
  
  /// Uploads a new property listing to the PostgreSQL database.
  ///
  /// Takes property data from the Houzi form (with shorthand field names)
  /// and converts it to PostgreSQL format. Handles:
  /// - User authentication (falls back to admin if not logged in)
  /// - Price extraction (including multi-unit floor plans)
  /// - Property details normalization (bedrooms, bathrooms, area, etc.)
  /// - Country and city assignment
  ///
  /// Returns a Map with success status and property ID on success
  static Future<Map<String, dynamic>> uploadProperty(Map<String, dynamic> propertyData) async {
    try {
      print('📤 PostgreSQL: Uploading property to database...');
      print('📋 ALL KEYS: ${propertyData.keys.join(', ')}');
      print('📋 SAMPLE VALUES:');
      print('   prop_beds: ${propertyData['prop_beds']}');
      print('   prop_baths: ${propertyData['prop_baths']}');
      print('   prop_size: ${propertyData['prop_size']}');
      print('   property_map_address: ${propertyData['property_map_address']}');
      print('   prop_title: ${propertyData['prop_title']}');
      
      // Extract data from Houzi format
      final loginData = HiveStorageManager.readUserLoginInfoData();
      String userId = loginData['user_id']?.toString() ?? '';
      if (userId.isEmpty) {
        userId = '550e8400-e29b-41d4-a716-446655440000';
        print('⚠️ No logged-in UUID user_id found, using fallback existing user ID: $userId');
      }
      final title = propertyData[ADD_PROPERTY_TITLE] ?? propertyData['prop_title'] ?? 'Untitled Property';
      final description = propertyData[ADD_PROPERTY_DESCRIPTION] ?? propertyData['prop_des'] ?? '';
      final propertyType = _extractPropertyType(propertyData);
      final listingType = _extractListingType(propertyData);
      final price = _extractPrice(propertyData);
      final bedrooms = _extractBedrooms(propertyData);
      final bathrooms = _extractBathrooms(propertyData);
      final area = _extractArea(propertyData);
      final address = _extractAddress(propertyData);
      
      print('📋 Property Details:');
      print('   Title: $title');
      print('   Price: $price');
      print('   Bedrooms: $bedrooms');
      print('   Bathrooms: $bathrooms');
      
      // Extract country_id directly from form data - dropdown provides it!
      int countryId = 1; // Default
      
      if (propertyData.containsKey('country_id')) {
        if (propertyData['country_id'] is int) {
          countryId = propertyData['country_id'];
        } else if (propertyData['country_id'] is String) {
          countryId = int.tryParse(propertyData['country_id'].toString()) ?? 1;
        }
      }
      
      print('🌍 DIRECT country_id from form: $countryId');
      print('📋 Form data country: ${propertyData['country']}');
      
      // Prepare data for PostgreSQL API
      final requestBody = {
        'user_id': userId,
        'title': title,
        'description': description,
        'property_type': propertyType,
        'listing_type': listingType,
        'status': 'active',
        'country_id': countryId,
        'city_id': '550e8400-e29b-41d4-a716-446655440001', // Default city
        'address': address,
        'bedrooms': bedrooms,
        'bathrooms': bathrooms,
        'area_sqm': area,
        'sale_price': price,
        'currency_code': 'USD',
      };
      
      print('🌐 Sending POST request to: $API_BASE_URL/properties');
      
      // Send POST request to PostgreSQL API
      final response = await http.post(
        Uri.parse('$API_BASE_URL/properties'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );
      
      print('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(response.body);
        print('✅ Property uploaded successfully!');
        print('   Property ID: ${result['property_id']}');
        
        return {
          'success': true,
          'property_id': result['property_id'],
          'message': 'Property uploaded to database',
        };
      } else {
        print('❌ Upload failed: ${response.body}');
        return {
          'success': false,
          'message': 'Failed to upload property: ${response.body}',
        };
      }
    } catch (e) {
      print('❌ Error uploading property: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
  
  /// Extract property type from Houzi form data
  /// 
  /// Houzi uses abbreviated fields: 'property_type' and 'fave_property_type'
  /// Maps to PostgreSQL: 'property_type' column
  /// Expected values: villa, apartment, house, land, commercial, etc.
  /// 
  /// Field priority:
  /// 1. property_type (quick add form)
  /// 2. fave_property_type (detailed form - "fave" = Houzi framework naming)
  /// 3. Default: 'house'
  static String _extractPropertyType(Map<String, dynamic> data) {
    if (data.containsKey('property_type')) {
      return data['property_type'].toString().toLowerCase();
    }
    if (data.containsKey('fave_property_type')) {
      return data['fave_property_type'].toString().toLowerCase();
    }
    return 'house'; // Default property type
  }
  
  /// Extract listing type (sale/rent/lease) from Houzi form data
  /// 
  /// Reads 'property_status' field to categorize property offering
  /// Maps to PostgreSQL: 'listing_type' column
  /// 
  /// Field aliases (Houzi convention):
  /// - property_status: Quick form status field
  /// - fave_property_status: Detailed form status ("fave" = Houzi framework)
  /// 
  /// Logic: Text-match keywords:
  /// - Contains 'rent' → 'rent'
  /// - Contains 'lease' → 'lease'
  /// - Default → 'sale'
  static String _extractListingType(Map<String, dynamic> data) {
    if (data.containsKey('property_status')) {
      String status = data['property_status'].toString().toLowerCase();
      if (status.contains('rent')) return 'rent';
      if (status.contains('lease')) return 'lease';
    }
    if (data.containsKey('fave_property_status')) {
      String status = data['fave_property_status'].toString().toLowerCase();
      if (status.contains('rent')) return 'rent';
      if (status.contains('lease')) return 'lease';
    }
    return 'sale'; // Default listing type
  }
  
  /// Extract price from multiple possible sources
  /// 
  /// Maps to PostgreSQL: 'sale_price' column (numeric integer)
  /// 
  /// HOUZI FIELD ABBREVIATIONS LEGEND:
  /// - prop_* : Abbreviated quick-add form fields (e.g., prop_price)
  /// - fave_* : Full framework property fields (e.g., fave_property_price)
  /// - ADD_PROPERTY_* : Constants for add property form (e.g., ADD_PROPERTY_PRICE)
  /// 
  /// Priority search order (first match wins):
  /// 1. sale_price (direct storage format)
  /// 2. fave_property_price (detailed form - most complete)
  /// 3. property_price (alternate form field)
  /// 4. prop_price (abbreviated quick-add field)
  /// 5. ADD_PROPERTY_PRICE (form constant)
  /// 6. price (generic field)
  /// 7. _price (alternate naming)
  /// 8. floor_plans[0]['fave_plan_price'] (multi-unit property workaround)
  /// 
  /// Cleanup: Removes all non-numeric characters before parsing
  static int _extractPrice(Map<String, dynamic> data) {
    // Check for 'sale_price' FIRST - this is what quick_add_property.dart sets!
    if (data.containsKey('sale_price')) {
      // It's already an int from the form, just return it
      if (data['sale_price'] is int) {
        print('✅ Found sale_price as int: ${data['sale_price']}');
        return data['sale_price'];
      }
      // If it's a string, parse it
      try {
        int price = int.parse(data['sale_price'].toString().replaceAll(RegExp(r'[^0-9]'), ''));
        print('✅ Parsed sale_price: $price');
        return price;
      } catch (e) {
        print('⚠️ Could not parse sale_price: ${data['sale_price']}');
      }
    }
    if (data.containsKey('fave_property_price')) {
      try {
        return int.parse(data['fave_property_price'].toString().replaceAll(RegExp(r'[^0-9]'), ''));
      } catch (e) {
        print('⚠️ Could not parse price: ${data['fave_property_price']}');
      }
    }
    if (data.containsKey('property_price')) {
      try {
        return int.parse(data['property_price'].toString().replaceAll(RegExp(r'[^0-9]'), ''));
      } catch (e) {
        print('⚠️ Could not parse price: ${data['property_price']}');
      }
    }
    if (data.containsKey('prop_price')) {
      try {
        return int.parse(data['prop_price'].toString().replaceAll(RegExp(r'[^0-9]'), ''));
      } catch (e) {
        print('⚠️ Could not parse price: ${data['prop_price']}');
      }
    }
    if (data.containsKey('ADD_PROPERTY_PRICE')) {
      try {
        return int.parse(data['ADD_PROPERTY_PRICE'].toString().replaceAll(RegExp(r'[^0-9]'), ''));
      } catch (e) {
        print('⚠️ Could not parse price: ${data['ADD_PROPERTY_PRICE']}');
      }
    }
    if (data.containsKey('price')) {
      try {
        return int.parse(data['price'].toString().replaceAll(RegExp(r'[^0-9]'), ''));
      } catch (e) {
        print('⚠️ Could not parse price: ${data['price']}');
      }
    }
    if (data.containsKey('_price')) {
      try {
        return int.parse(data['_price'].toString().replaceAll(RegExp(r'[^0-9]'), ''));
      } catch (e) {
        print('⚠️ Could not parse price: ${data['_price']}');
      }
    }
    
    // WORKAROUND: Try to get price from floor plans (slide 7/8)
    print('💡 Main price not found, checking floor plans...');
    if (data.containsKey('floor_plans') && data['floor_plans'] != null) {
      var floorPlans = data['floor_plans'];
      print('📋 Floor plans data type: ${floorPlans.runtimeType}');
      if (floorPlans is List && floorPlans.isNotEmpty) {
        print('📋 Found ${floorPlans.length} floor plans');
        var firstPlan = floorPlans[0];
        if (firstPlan is Map && firstPlan.containsKey('fave_plan_price')) {
          try {
            var planPrice = firstPlan['fave_plan_price'];
            if (planPrice != null && planPrice.toString().isNotEmpty) {
              int parsedPrice = int.parse(planPrice.toString().replaceAll(RegExp(r'[^0-9]'), ''));
              print('💰 Using price from floor plan: $parsedPrice');
              return parsedPrice;
            }
          } catch (e) {
            print('⚠️ Error parsing floor plan price: $e');
          }
        }
      }
    }
    
    print('⚠️ No price field found in data! Available keys: ${data.keys.join(', ')}');
    return 0;
  }
  

  
  /// Extract bedrooms from Houzi form data
  /// 
  /// Maps to PostgreSQL: 'bedrooms' column (integer count)
  /// 
  /// Houzi abbreviations:
  /// - fave_property_bedrooms : Detailed form bedroom count ("fave" = framework standard)
  /// - bedrooms : Generic field name
  /// - prop_beds : Abbreviated quick-add form ("prop" = quick property)
  /// 
  /// Returns: Integer count, or 0 if not specified
  static int _extractBedrooms(Map<String, dynamic> data) {
    if (data.containsKey('fave_property_bedrooms')) {
      try {
        return int.parse(data['fave_property_bedrooms'].toString());
      } catch (e) {}
    }
    if (data.containsKey('bedrooms')) {
      try {
        return int.parse(data['bedrooms'].toString());
      } catch (e) {}
    }
    if (data.containsKey('prop_beds')) {
      try {
        return int.parse(data['prop_beds'].toString());
      } catch (e) {}
    }
    return 0;
  }
  
  /// Extract bathrooms from Houzi form data
  /// 
  /// Maps to PostgreSQL: 'bathrooms' column (integer count)
  /// 
  /// Houzi abbreviations:
  /// - fave_property_bathrooms : Detailed form bathroom count ("fave" = framework standard)
  /// - bathrooms : Generic field name
  /// - prop_baths : Abbreviated quick-add form ("prop" = quick property, "baths" = shortened)
  /// 
  /// Returns: Integer count, or 0 if not specified
  static int _extractBathrooms(Map<String, dynamic> data) {
    if (data.containsKey('fave_property_bathrooms')) {
      try {
        return int.parse(data['fave_property_bathrooms'].toString());
      } catch (e) {}
    }
    if (data.containsKey('bathrooms')) {
      try {
        return int.parse(data['bathrooms'].toString());
      } catch (e) {}
    }
    if (data.containsKey('prop_baths')) {
      try {
        return int.parse(data['prop_baths'].toString());
      } catch (e) {}
    }
    return 0;
  }
  
  /// Extract property area/size from Houzi form data
  /// 
  /// Maps to PostgreSQL: 'area_sqm' column (square meters, integer)
  /// 
  /// Houzi abbreviations:
  /// - fave_property_size : Detailed form property size ("fave" = framework standard)
  /// - property_size : Generic size field
  /// 
  /// Cleanup: Removes non-numeric characters before parsing (handles "1000 sqm" → "1000")
  /// Returns: Integer area in square meters, or 0 if not specified
  static int _extractArea(Map<String, dynamic> data) {
    if (data.containsKey('fave_property_size')) {
      try {
        return int.parse(data['fave_property_size'].toString().replaceAll(RegExp(r'[^0-9]'), ''));
      } catch (e) {}
    }
    if (data.containsKey('property_size')) {
      try {
        return int.parse(data['property_size'].toString().replaceAll(RegExp(r'[^0-9]'), ''));
      } catch (e) {}
    }
    return 0;
  }
  
  
  /// Extract property address from Houzi form data
  /// 
  /// Maps to PostgreSQL: 'address' column (text, street address)
  /// 
  /// Houzi abbreviations:
  /// - fave_property_address : Detailed form address ("fave" = framework standard)
  /// - property_address : Generic address field
  /// - property_map_address : Address from map picker widget
  /// - address : Generic field name
  /// - prop_address : Abbreviated quick-add form
  /// 
  /// Priority: Checks multiple sources due to various Houzi form implementations
  /// Returns: Address string, or empty string if not specified
  static String _extractAddress(Map<String, dynamic> data) {
    if (data.containsKey('fave_property_address')) {
      return data['fave_property_address'].toString();
    }
    if (data.containsKey('property_address')) {
      return data['property_address'].toString();
    }
    if (data.containsKey('property_map_address')) {
      return data['property_map_address'].toString();
    }
    if (data.containsKey('address')) {
      return data['address'].toString();
    }
    if (data.containsKey('prop_address')) {
      return data['prop_address'].toString();
    }
    return '';
  }
  
}
