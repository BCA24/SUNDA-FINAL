import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/caribbean_property.dart';
import '../widgets/caribbean_property_filter.dart';

/// Database Service - PostgreSQL API Client
/// 
/// Connects Flutter app to PostgreSQL database through Node.js REST API
/// Maps form data and queries to/from database schema
/// 
/// FIELD MAPPING (Houzi → PostgreSQL):
/// Database columns in properties table:
/// - title (string) ← prop_title, fave_property_title
/// - description (text) ← prop_des, fave_property_description  
/// - property_type (string) ← property_type, fave_property_type (villa, apartment, house, etc.)
/// - listing_type (string) ← property_status, fave_property_status (sale, rent, lease)
/// - sale_price (integer) ← prop_price, fave_property_price
/// - bedrooms (integer) ← prop_beds, fave_property_bedrooms
/// - bathrooms (integer) ← prop_baths, fave_property_bathrooms
/// - area_sqm (integer) ← prop_size, fave_property_size
/// - address (string) ← property_map_address, fave_property_address
/// - country_id (integer FK) → countries table
/// - city_id (integer FK) → cities table
/// - user_id (UUID FK) → users table (owner who listed property)
/// - status (string) → 'active', 'inactive', 'sold'
/// - created_at, updated_at (timestamps)
/// 
/// API Base URL: http://10.0.2.2:3000/api (emulator) / http://localhost:3000/api (host)
class DatabaseService {
  // In production, this should be your server URL
  // For testing, you can use a local API server or direct database connection
  // Use 10.0.2.2 for Android emulator (maps to host localhost)
  static const String baseUrl = 'http://10.0.2.2:3000/api'; // Your API server
  
  // Alternative: Direct database connection (requires postgres_dart package)
  // static const String connectionString = 'postgresql://caribbean_user:caribbean_secure_2024!@localhost:5432/caribbean_real_estate';

  /// Get properties by country with filtering
  static Future<List<CaribbeanProperty>> getPropertiesByCountry(
    String countryCode, {
    PropertyFilterCriteria? filters,
  }) async {
    try {
      // Build query parameters
      Map<String, String> queryParams = {
        'country': countryCode,
        'status': 'active',
      };

      // Add filter parameters if provided
      if (filters != null) {
        if (filters.propertyType != null) {
          queryParams['property_type'] = _mapPropertyTypeToDb(filters.propertyType!);
        }
        if (filters.selectedCity != null) {
          queryParams['city'] = filters.selectedCity!.split(',').first; // Extract city name
        }
        if (filters.minPrice > 0) {
          queryParams['min_price'] = filters.minPrice.toString();
        }
        if (filters.maxPrice < 2000000) {
          queryParams['max_price'] = filters.maxPrice.toString();
        }
        if (filters.bedrooms != null) {
          queryParams['bedrooms'] = filters.bedrooms.toString();
        }
        if (filters.bathrooms != null) {
          queryParams['bathrooms'] = filters.bathrooms.toString();
        }
        if (filters.nearSea) {
          queryParams['near_beach'] = 'true';
        }
        if (filters.hasPool) {
          queryParams['has_pool'] = 'true';
        }
        if (filters.hasGarden) {
          queryParams['has_garden'] = 'true';
        }
        if (filters.hasParking) {
          queryParams['has_parking'] = 'true';
        }
        if (filters.furnished != null) {
          queryParams['furnished'] = filters.furnished == 'Yes' ? 'true' : 'false';
        }
        if (filters.hasSecurity) {
          queryParams['gated_community'] = 'true';
        }
        if (filters.hasBalcony) {
          queryParams['ocean_view'] = 'true';
        }
      }

      // Make API request
      final uri = Uri.parse('$baseUrl/properties').replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => CaribbeanProperty.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load properties: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching properties: $e');
      // Fallback to mock data for testing
      return _getMockPropertiesByCountry(countryCode, filters);
    }
  }

  /// Get all countries with property counts
  static Future<List<Map<String, dynamic>>> getCountriesWithPropertyCounts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/countries'));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (e) {
      print('Error fetching countries: $e');
      // Fallback to mock data
      return _getMockCountries();
    }
  }

  /// User authentication
  static Future<Map<String, dynamic>?> authenticateUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error authenticating user: $e');
      return null;
    }
  }

  /// Create new property listing
  static Future<bool> createProperty(Map<String, dynamic> propertyData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/properties'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(propertyData),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error creating property: $e');
      return false;
    }
  }

  /// Get property details by ID
  static Future<CaribbeanProperty?> getPropertyById(String propertyId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/properties/$propertyId'));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return CaribbeanProperty.fromJson(jsonData);
      }
      return null;
    } catch (e) {
      print('Error fetching property: $e');
      return null;
    }
  }

  /// Add property to user favorites
  static Future<bool> addToFavorites(String userId, String propertyId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/$userId/favorites'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'property_id': propertyId}),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error adding to favorites: $e');
      return false;
    }
  }

  /// Submit property inquiry
  static Future<bool> submitInquiry(Map<String, dynamic> inquiryData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/inquiries'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(inquiryData),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error submitting inquiry: $e');
      return false;
    }
  }

  // Helper method to map Flutter property types to database enum values
  static String _mapPropertyTypeToDb(String flutterType) {
    switch (flutterType.toLowerCase()) {
      case 'apartment':
        return 'apartment';
      case 'villa':
        return 'villa';
      case 'house':
        return 'house';
      case 'condo':
        return 'condo';
      case 'townhouse':
        return 'townhouse';
      case 'penthouse':
        return 'penthouse';
      case 'beach house':
        return 'beach_house';
      case 'resort property':
        return 'resort_property';
      case 'commercial':
        return 'commercial';
      case 'land/plot':
        return 'land_plot';
      default:
        return 'house';
    }
  }

  // Fallback mock data for testing when database is not available
  static List<CaribbeanProperty> _getMockPropertiesByCountry(String countryCode, PropertyFilterCriteria? filters) {
    // Use your existing mock data as fallback
    final allProperties = CaribbeanPropertyData.getAllProperties();
    
    // Filter by country
    List<CaribbeanProperty> countryProperties;
    switch (countryCode.toUpperCase()) {
      case 'JAM':
        countryProperties = allProperties.where((p) => p.country == 'Jamaica').toList();
        break;
      case 'BHS':
        countryProperties = allProperties.where((p) => p.country == 'Bahamas').toList();
        break;
      case 'BRB':
        countryProperties = allProperties.where((p) => p.country == 'Barbados').toList();
        break;
      case 'TTO':
        countryProperties = allProperties.where((p) => p.country == 'Trinidad').toList();
        break;
      default:
        countryProperties = allProperties;
    }

    // Apply filters if provided
    if (filters != null) {
      countryProperties = countryProperties.where((property) {
        return property.matchesFilter(
          propertyType: filters.propertyType,
          selectedCity: filters.selectedCity,
          minPrice: filters.minPrice,
          maxPrice: filters.maxPrice,
          bedrooms: filters.bedrooms,
          bathrooms: filters.bathrooms,
          nearSea: filters.nearSea,
          hasPoolFilter: filters.hasPool,
          hasGardenFilter: filters.hasGarden,
          hasParkingFilter: filters.hasParking,
          furnishedFilter: filters.furnished == 'Yes',
          gatedCommunityFilter: filters.hasSecurity,
          oceanViewFilter: filters.hasBalcony,
        );
      }).toList();
    }

    return countryProperties;
  }

  static List<Map<String, dynamic>> _getMockCountries() {
    return [
      {'code': 'JAM', 'name': 'Jamaica', 'region': 'West', 'property_count': 6},
      {'code': 'BHS', 'name': 'Bahamas', 'region': 'West', 'property_count': 3},
      {'code': 'BRB', 'name': 'Barbados', 'region': 'East', 'property_count': 3},
      {'code': 'TTO', 'name': 'Trinidad and Tobago', 'region': 'West', 'property_count': 2},
      {'code': 'GUY', 'name': 'Guyana', 'region': 'Mainland', 'property_count': 2},
      {'code': 'SUR', 'name': 'Suriname', 'region': 'Mainland', 'property_count': 1},
    ];
  }
}

/// Extension to add JSON serialization to CaribbeanProperty
extension CaribbeanPropertyJson on CaribbeanProperty {
  static CaribbeanProperty fromJson(Map<String, dynamic> json) {
    return CaribbeanProperty(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['sale_price'] ?? json['rent_price_monthly'] ?? 0).toDouble(),
      currency: json['currency_code'] ?? 'USD',
      propertyType: json['property_type'] ?? 'house',
      city: json['city_name'] ?? json['city'] ?? '',
      country: json['country_name'] ?? json['country'] ?? '',
      region: json['region'] ?? 'West',
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms']?.toInt() ?? 0,
      area: (json['area_sqm'] ?? 0).toDouble(),
      images: json['images'] is List 
          ? List<String>.from(json['images']) 
          : [json['primary_image'] ?? ''].where((img) => img.isNotEmpty).toList(),
      amenities: json['amenities'] is List 
          ? List<String>.from(json['amenities'])
          : <String>[],
      nearBeach: json['near_beach'] ?? false,
      oceanView: json['ocean_view'] ?? false,
      furnished: json['furnished'] ?? false,
      hasPool: json['has_pool'] ?? false,
      hasGarden: json['has_garden'] ?? false,
      hasParking: json['has_parking'] ?? false,
      gatedCommunity: json['gated_community'] ?? false,
      newConstruction: json['new_construction'] ?? false,
      constructionYear: json['construction_year'] ?? 2000,
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      contactPhone: json['contact_phone'] ?? '',
      contactEmail: json['contact_email'] ?? '',
      listedDate: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      isAvailable: json['status'] == 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'sale_price': price,
      'currency_code': currency,
      'property_type': propertyType.toLowerCase().replaceAll(' ', '_'),
      'city': city,
      'country': country,
      'region': region,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area_sqm': area,
      'images': images,
      'amenities': amenities,
      'near_beach': nearBeach,
      'ocean_view': oceanView,
      'furnished': furnished,
      'has_pool': hasPool,
      'has_garden': hasGarden,
      'has_parking': hasParking,
      'gated_community': gatedCommunity,
      'new_construction': newConstruction,
      'construction_year': constructionYear,
      'latitude': latitude,
      'longitude': longitude,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'created_at': listedDate.toIso8601String(),
      'status': isAvailable ? 'active' : 'inactive',
    };
  }
}
