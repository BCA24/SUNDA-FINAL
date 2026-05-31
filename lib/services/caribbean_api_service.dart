import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:houzi_package/models/article.dart';

class CaribbeanApiService {
  // Use 10.0.2.2 for Android emulator (maps to host machine's localhost)
  // For physical phone on same network, use: http://172.16.100.201:3000/api
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  
  // Use emulator-friendly address
  static String get apiUrl {
    return baseUrl;
  }

  // Test database connection by pinging a real endpoint
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/properties?limit=1'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  // Fetch properties from local PostgreSQL database
  static Future<List<Article>> fetchProperties({
    String? country,
    String? propertyType,
    int? minBedrooms,
    int? maxBedrooms,
    int? minBathrooms,
    int? maxBathrooms,
    double? minPrice,
    double? maxPrice,
    List<String>? amenities,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Build query parameters
      Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (country != null && country.isNotEmpty) {
        queryParams['country'] = country;
      }
      if (propertyType != null && propertyType.isNotEmpty) {
        queryParams['property_type'] = propertyType;
      }
      if (minBedrooms != null) {
        queryParams['min_bedrooms'] = minBedrooms.toString();
      }
      if (maxBedrooms != null) {
        queryParams['max_bedrooms'] = maxBedrooms.toString();
      }
      if (minBathrooms != null) {
        queryParams['min_bathrooms'] = minBathrooms.toString();
      }
      if (maxBathrooms != null) {
        queryParams['max_bathrooms'] = maxBathrooms.toString();
      }
      if (minPrice != null) {
        queryParams['min_price'] = minPrice.toString();
      }
      if (maxPrice != null) {
        queryParams['max_price'] = maxPrice.toString();
      }
      if (amenities != null && amenities.isNotEmpty) {
        queryParams['amenities'] = amenities.join(',');
      }

      // Create URI with query parameters
      final uri = Uri.parse('$apiUrl/properties').replace(
        queryParameters: queryParams,
      );

      print('🔍 Fetching properties from: $uri');

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      print('📤 Response status: ${response.statusCode}');
      print('📦 Response body preview: ${response.body.length > 200 ? response.body.substring(0, 200) + "..." : response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> propertiesData = jsonData['data'] ?? jsonData;

        print('✅ Found ${propertiesData.length} properties in response');
        
        List<Article> articles = propertiesData.map((propertyJson) {
          print('🔄 Converting property from database: ${propertyJson['title']} (ID: ${propertyJson['id']})');
          print('📍 Raw address from DB: ${propertyJson['address']}');
          final article = _convertToArticle(propertyJson);
          print('🏠 Converted Article address: ${article.address?.address}');
          return article;
        }).toList();
        
        print('📋 Returning ${articles.length} converted articles');
        return articles;
      } else {
        print('Failed to fetch properties: ${response.statusCode}');
        print('Response body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching properties: $e');
      return [];
    }
  }

  // Fetch countries with property counts
  static Future<List<Map<String, dynamic>>> fetchCountries() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/countries'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> countriesData = jsonData['data'] ?? jsonData;
        
        return countriesData.cast<Map<String, dynamic>>();
      } else {
        print('Failed to fetch countries: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching countries: $e');
      return [];
    }
  }

  // Convert database property to Article model
  static Article _convertToArticle(Map<String, dynamic> propertyJson) {
    // Convert PostgreSQL property data to Houzi Article format
    print('🔄 Converting property from database: ${propertyJson['title']} (ID: ${propertyJson['id']})');
    print('📊 RAW DATABASE JSON: ${propertyJson.toString()}');
    print('📊 Database fields: sale_price=${propertyJson['sale_price']}, bedrooms=${propertyJson['bedrooms']}, bathrooms=${propertyJson['bathrooms']}, area_sqm=${propertyJson['area_sqm']}');
    print('📍 Address fields: address=${propertyJson['address']}, city_name=${propertyJson['city_name']}, country_name=${propertyJson['country_name']}');
    
    final article = Article(
      id: propertyJson['id'] ?? 0,
      title: propertyJson['title'] ?? 'Caribbean Property',
      content: propertyJson['description'] ?? '',
      type: 'property',
      status: 'publish',
      dateGMT: propertyJson['created_at'] ?? DateTime.now().toIso8601String(),
      modifiedDate: propertyJson['updated_at'] ?? DateTime.now().toIso8601String(),
      link: '',
      image: propertyJson['primary_image'] ?? '',
      imageList: _parseImageList(propertyJson['image_gallery']),
    );

    // Extract price from database fields (sale_price, rent_price_monthly)
    final salePrice = propertyJson['sale_price'] ?? 0;
    final rentPrice = propertyJson['rent_price_monthly'] ?? 0;
    final finalPrice = salePrice > 0 ? salePrice : rentPrice;
    final priceDisplay = finalPrice > 0 ? finalPrice.toString() : '0';
    
    print('💰 Price conversion: sale_price=$salePrice, rent_price=$rentPrice → final_price=$finalPrice');

    // Set property info with correct database field mapping
    article.propertyInfo = PropertyInfo(
      price: priceDisplay,
      firstPrice: priceDisplay,
      priceDisplay: '\$${_formatPrice(finalPrice)}',
      pricePostfix: propertyJson['currency_code'] ?? 'USD',
      propertyType: propertyJson['property_type'] ?? 'House',
      propertyStatus: propertyJson['listing_type'] == 'sale' ? 'For Sale' : 'For Rent',
      propertyLabel: propertyJson['label'] ?? '',
      requiredLogin: false,
      featured: propertyJson['is_featured'] == true ? '1' : '0',
    );

    // Set features with correct database field mapping
    article.features = Features(
      bedrooms: propertyJson['bedrooms']?.toString() ?? '0',
      bathrooms: propertyJson['bathrooms']?.toString() ?? '0',
      buildingArea: propertyJson['area_sqm']?.toString() ?? '0',
      buildingAreaUnit: 'sq m',
      yearBuilt: propertyJson['construction_year']?.toString() ?? '',
    );

    // Set address with correct database field mapping
    article.address = Address(
      address: propertyJson['address'] ?? '',
      lat: propertyJson['latitude']?.toString() ?? '0',
      long: propertyJson['longitude']?.toString() ?? '0',
      coordinates: '${propertyJson['latitude'] ?? 0},${propertyJson['longitude'] ?? 0}',
      country: propertyJson['country_name'] ?? '',
      state: propertyJson['state_name'] ?? '',
      city: propertyJson['city_name'] ?? '',
      area: propertyJson['area_name'] ?? '',
    );

    // Set property details map for detail screen access
    article.propertyDetailsMap = {
      'property_address': propertyJson['address'] ?? '',
      'property_country': propertyJson['country_name'] ?? '',
      'property_city': propertyJson['city_name'] ?? '',
      'property_state': propertyJson['state_name'] ?? '',
      'property_price': finalPrice.toString(),
      'property_type': propertyJson['property_type'] ?? 'House',
      'property_year_built': propertyJson['construction_year']?.toString() ?? '',
    };

    print('✅ Converted to Article: ${article.title} - ${article.propertyFeatures?.bedrooms} beds, ${article.propertyFeatures?.bathrooms} baths, \$${_formatPrice(finalPrice)}');
    return article;
  }

  // Parse image gallery JSON to list
  static List<String> _parseImageList(dynamic imageGallery) {
    if (imageGallery == null) return [];
    
    if (imageGallery is String) {
      try {
        final List<dynamic> parsed = json.decode(imageGallery);
        return parsed.cast<String>();
      } catch (e) {
        return [imageGallery];
      }
    } else if (imageGallery is List) {
      return imageGallery.cast<String>();
    }
    
    return [];
  }

  // Create new property
  static Future<bool> createProperty(Map<String, dynamic> propertyData) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/properties'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(propertyData),
      ).timeout(Duration(seconds: 15));

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print('Error creating property: $e');
      return false;
    }
  }

  // Test database and show status
  static Future<void> showConnectionStatus() async {
    print('🔍 Testing Caribbean API connection...');
    
    final isConnected = await testConnection();
    if (isConnected) {
      print('✅ Successfully connected to Caribbean Real Estate API');
      
      // Test fetching properties
      final properties = await fetchProperties(limit: 3);
      print('📊 Found ${properties.length} properties in database');
      
      // Test fetching countries
      final countries = await fetchCountries();
      print('🌍 Found ${countries.length} countries available');
      
    } else {
      print('❌ Failed to connect to Caribbean Real Estate API');
      print('💡 Make sure your Node.js server is running on port 3000');
    }
  }

  // Save a new property to PostgreSQL database
  static Future<Map<String, dynamic>> saveProperty(Map<String, dynamic> propertyData) async {
    try {
      print('💾 Saving property to PostgreSQL database...');
      print('📝 Property data keys: ${propertyData.keys.join(', ')}');
      
      final response = await http.post(
        Uri.parse('$apiUrl/properties'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(propertyData),
      ).timeout(Duration(seconds: 15));

      print('📤 Save property response: ${response.statusCode}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final result = json.decode(response.body);
        print('✅ Property saved successfully! ID: ${result['id']}');
        return {'success': true, 'data': result, 'message': 'Property saved successfully'};
      } else {
        print('❌ Failed to save property: ${response.statusCode}');
        print('❌ Response: ${response.body}');
        return {'success': false, 'error': 'Failed to save property: ${response.statusCode}'};
      }
    } catch (e) {
      print('❌ Error saving property: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // Convert Flutter property data to API format matching server expectations
  static Map<String, dynamic> convertPropertyToApiFormat(Map<String, dynamic> flutterData) {
    // Extract actual form values using correct field names
    final title = flutterData['prop_title'] ?? flutterData['property_title'] ?? flutterData['title'] ?? 'Untitled Property';
    final description = flutterData['prop_des'] ?? flutterData['property_description'] ?? flutterData['content'] ?? 'No description provided';
    final address = flutterData['property_map_address'] ?? flutterData['property_address'] ?? flutterData['address'] ?? 'Address not specified';
    
    // Parse numeric values from actual form fields
    final bedrooms = int.tryParse((flutterData['prop_beds'] ?? flutterData['property_bedrooms'] ?? flutterData['bedrooms'] ?? '1').toString()) ?? 1;
    final bathrooms = int.tryParse((flutterData['prop_baths'] ?? flutterData['property_bathrooms'] ?? flutterData['bathrooms'] ?? '1').toString()) ?? 1;
    final area = double.tryParse((flutterData['prop_size'] ?? flutterData['property_size'] ?? flutterData['area'] ?? '100').toString()) ?? 100.0;
    
    // Parse price correctly - check multiple possible field names
    // Extract price from form data - FIXED to check multi-unit price
    print('🔍 PRICE DEBUGGING:');
    final priceFields = ['prop_price', 'property_price', 'price', 'fave_property_price', 'PRICE'];
    for (String field in priceFields) {
      print('  - $field: ${flutterData[field]}');
    }
    
    // Check for price in multi-unit data (this is where Houzi stores the price!)
    String priceValue = "0";
    if (flutterData['fave_multi_units'] != null && flutterData['fave_multi_units'] is List) {
      final multiUnits = flutterData['fave_multi_units'] as List;
      if (multiUnits.isNotEmpty && multiUnits[0] is Map) {
        final firstUnit = multiUnits[0] as Map;
        final muPrice = firstUnit['fave_mu_price'];
        if (muPrice != null && muPrice.toString().isNotEmpty) {
          priceValue = muPrice.toString();
          print('  💰 Found price in fave_multi_units[0].fave_mu_price: $priceValue');
        }
      }
    }
    
    // Fallback to regular price fields
    if (priceValue == "0") {
      priceValue = flutterData['prop_price']?.toString() ?? 
                   flutterData['property_price']?.toString() ?? 
                   flutterData['price']?.toString() ?? "0";
    }
    
    print('  - Selected price value: "$priceValue" (type: ${priceValue.runtimeType})');
    final price = _parseDouble(priceValue) ?? 0.0;
    print('  - Parsed price: $price');
    
    // Get country ID from the form
    final countryValue = flutterData['country'] ?? flutterData['property_country'] ?? flutterData['country_code'] ?? '';
    final countryId = _getCountryId(countryValue.toString());
    
    print('🔍 Extracting form data:');
    print('  - Title: "$title" (from ${flutterData['prop_title'] != null ? 'prop_title' : 'default'})');
    print('  - Description: "${description.length > 50 ? description.substring(0, 50) + '...' : description}" (from ${flutterData['prop_des'] != null ? 'prop_des' : 'default'})');
    print('  - Address: "$address" (from ${flutterData['property_map_address'] != null ? 'property_map_address' : 'default'})');
    print('  - Bedrooms: $bedrooms (from ${flutterData['prop_beds'] != null ? 'prop_beds' : 'default'})');
    print('  - Bathrooms: $bathrooms (from ${flutterData['prop_baths'] != null ? 'prop_baths' : 'default'})');
    print('  - Area: $area sqm (from ${flutterData['prop_size'] != null ? 'prop_size' : 'default'})');
    // Extract city name from form
    final String cityName = flutterData['locality'] ?? 
                           flutterData['city'] ?? 
                           flutterData['prop_city'] ?? 
                           '';
    
    print('  - Final Price: \$${price}');
    print('  - Country: "$countryValue" → ID: $countryId');
    print('  - City: "$cityName" (will be created/found in database)');
    
    final result = <String, dynamic>{
      // Required fields matching server schema
      'user_id': 'cd29948f-a00f-44ff-beab-101f8664a46f', // Use logged-in user ID
      'title': title,
      'description': description,
      'property_type': flutterData['property_type'] ?? 'house',
      'listing_type': 'sale', // Default to sale
      'country_id': countryId, // Integer ID for database
      'city_name': cityName, // Send city name instead of city_id
      'address': address,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area_sqm': area,
      'sale_price': price,
      'currency_code': flutterData['currency'] ?? flutterData['property_currency'] ?? 'USD',
      'contact_email': 'berk@live.nl', // Use logged-in user email
    };
    
    // Only add optional fields if they have valid values
    final lat = _parseDouble(flutterData['lat'] ?? flutterData['property_latitude']);
    final lng = _parseDouble(flutterData['lng'] ?? flutterData['property_longitude']);
    
    if (lat != null && lng != null) {
      result['latitude'] = lat;
      result['longitude'] = lng;
    }
    
    return result;
  }

  // Helper method to get country ID from country name
  static int _getCountryId(String countryName) {
    // Map country names to integer IDs matching database schema - default to Jamaica if not found
    final countryMap = {
      // Database mapping based on countries table
      'Jamaica': 1,         // JAM
      'Bahamas': 2,         // BHS  
      'Cuba': 3,            // CUB
      'Haiti': 4,           // HTI
      'Dominican Republic': 5, // DOM
      'Puerto Rico': 6,     // PRI
      'Trinidad and Tobago': 7, // TTO
      'Curaçao': 8,         // CUW
      'Aruba': 9,           // ABW
      'Barbados': 10,       // BRB
      'Saint Lucia': 11,    // LCA
      'Grenada': 12,        // GRD
      'Saint Vincent and the Grenadines': 13, // VCT
      'Dominica': 14,       // DMA
      'Antigua and Barbuda': 15, // ATG
      'Saint Kitts and Nevis': 16, // KNA
      'Martinique': 17,     // MTQ
      'Guadeloupe': 18,     // GLP
      'British Virgin Islands': 19, // VGB
      'US Virgin Islands': 20, // VIR
      'Guyana': 21,         // GUY
      'Suriname': 22,       // SUR
      'French Guiana': 23,  // GUF
      'Belize': 24,         // BLZ
      
      // Also handle lowercase versions
      'jamaica': 1,
      'bahamas': 2, 
      'cuba': 3,
      'haiti': 4,
      'dominican republic': 5,
      'puerto rico': 6,
      'trinidad and tobago': 7,
      'trinidad': 7,
      'curaçao': 8,
      'curacao': 8,
      'aruba': 9,
      'barbados': 10,
      'saint lucia': 11,
      'st. lucia': 11,
      'grenada': 12,
      'saint vincent': 13,
      'dominica': 14,
      'antigua': 15,
      'saint kitts': 16,
      'martinique': 17,
      'guadeloupe': 18,
      'british virgin islands': 19,
      'us virgin islands': 20,
      'guyana': 21,
      'suriname': 22,
      'french guiana': 23,
      'belize': 24,
      
      // Handle country codes too
      'JAM': 1,
      'BHS': 2,
      'CUB': 3,
      'HTI': 4,
      'DOM': 5,
      'PRI': 6,
      'TTO': 3,
      'CUW': 8,
      'ABW': 9,
      'BRB': 10,
      'LCA': 11,
      'GRD': 12,
      'VCT': 13,
      'DMA': 14,
      'ATG': 15,
      'KNA': 16,
      'MTQ': 17,
      'GLP': 18,
      'VGB': 19,
      'VIR': 20,
      'GUY': 21,
      'SUR': 22,
      'GUF': 23,
      'BLZ': 24,
    };
    return countryMap[countryName] ?? 1; // Default to Jamaica
  }

  // Helper method to safely parse double values
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      // Remove common formatting characters
      String cleanValue = value
          .replaceAll(',', '')  // Remove commas: "5,000,000" → "5000000"
          .replaceAll(' ', '')  // Remove spaces: "5 000 000" → "5000000"  
          .replaceAll('\$', '') // Remove dollar signs: "$5000000" → "5000000"
          .replaceAll('€', '')  // Remove euro signs
          .replaceAll('£', '')  // Remove pound signs
          .trim();
      
      print('    🔢 Parsing "$value" → cleaned: "$cleanValue"');
      final result = double.tryParse(cleanValue);
      print('    📊 Result: $result');
      return result;
    }
    return null;
  }

  // Helper method to format price for display
  static String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    } else {
      return price.toStringAsFixed(0);
    }
  }
}