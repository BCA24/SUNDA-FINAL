import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/common/constants.dart';

class AgencyAuthService {
  // Use 10.0.2.2 for Android emulator (maps to host machine's localhost)
  // For physical device on same network, use: http://172.16.100.201:3000/api
  static const String BASE_URL = 'http://10.0.2.2:3000/api';
  
  // User roles
  static const String ROLE_AGENCY = 'agency';
  static const String ROLE_GUEST = 'guest';
  
  /// Store agency session after successful login
  static Future<void> saveAgencySession(Map<String, dynamic> data) async {
    Map<String, dynamic> loginData = {
      'token': data['session_token'],
      'user_email': data['user']['email'],
      'user_display_name': data['user']['name'],
      'user_id': data['user']['id'].toString(),
      'user_role': [USER_ROLE_AGENCY_VALUE], // Use the correct app constant: 'houzez_agency'
      'user_nicename': data['user']['name'].toString().toLowerCase().replaceAll(' ', '_'),
      'avatar': data['user']['avatar'] ?? '',
      'fave_author_agent_id': data['user']['id'].toString(),  // Critical for Add Property access!
      'user_login': data['user']['email'],  // Add user login field
    };
    
    HiveStorageManager.storeUserLoginInfoData(loginData);
    HiveStorageManager.saveData(key: USER_LOGGED_IN, data: true);
    
    print('✅ Agency session saved: ${data['user']['role']}');
  }
  
  /// Store guest session (limited access)
  static Future<void> saveGuestSession() async {
    Map<String, dynamic> loginData = {
      'token': 'guest_token_${DateTime.now().millisecondsSinceEpoch}',
      'user_email': 'guest@suristay.com',
      'user_display_name': 'Guest User',
      'user_id': '0',
      'user_role': [USER_ROLE_BUYER_VALUE], // Use the correct app constant: 'houzez_buyer'
      'user_nicename': 'guest_user',
      'avatar': '',
      'user_login': 'guest_user',  // Add user login field
      // No fave_author_agent_id for guests - they can't add properties
    };
    
    HiveStorageManager.storeUserLoginInfoData(loginData);
    HiveStorageManager.saveData(key: USER_LOGGED_IN, data: true);
    
    print('✅ Guest session saved');
  }
  
  /// Check if current user is an agency
  static bool isAgency() {
    String userRole = HiveStorageManager.getUserRole();
    return userRole == USER_ROLE_AGENCY_VALUE; // Only check for the actual app constant
  }
  
  /// Check if current user is a guest
  static bool isGuest() {
    String userRole = HiveStorageManager.getUserRole();
    return userRole == USER_ROLE_BUYER_VALUE; // Only check for the actual app constant
  }
  
  /// Check if user can add properties (agencies only)
  static bool canAddProperties() {
    return isAgency();
  }
  
  /// Agency Login
  static Future<Map<String, dynamic>> agencyLogin(String email, String password) async {
    try {
      // First try to connect to API server
      final response = await http.post(
        Uri.parse('$BASE_URL/auth/agency-login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          await saveAgencySession(data);
          return {'success': true, 'user': data['user']};
        } else {
          return {'success': false, 'error': data['message'] ?? 'Login failed'};
        }
      } else {
        return {'success': false, 'error': 'Server error: ${response.statusCode}'};
      }
    } catch (e) {
      print('❌ Agency login API error: $e, falling back to local auth');
      
      // Fallback to local authentication for testing
      return _localAgencyLogin(email, password);
    }
  }
  
  /// Local fallback authentication for testing
  static Future<Map<String, dynamic>> _localAgencyLogin(String email, String password) async {
    // Simple hardcoded agencies for testing
    List<Map<String, dynamic>> testAgencies = [
      {'email': 'agency@suristay.com', 'password': 'agency123', 'name': 'SuriStay Agency', 'id': 1},
      {'email': 'caribbean@realty.com', 'password': 'caribbean123', 'name': 'Caribbean Realty', 'id': 2},
      {'email': 'test@agency.com', 'password': 'test123', 'name': 'Test Agency', 'id': 3},
    ];
    
    for (var agency in testAgencies) {
      if (agency['email'] == email && agency['password'] == password) {
        Map<String, dynamic> sessionData = {
          'session_token': 'local_token_${DateTime.now().millisecondsSinceEpoch}',
          'user': {
            'id': agency['id'],
            'email': agency['email'],
            'name': agency['name'],
            'role': USER_ROLE_AGENCY_VALUE, // Use the correct app constant: 'houzez_agency'
            'avatar': '',
          }
        };
        
        await saveAgencySession(sessionData);
        return {'success': true, 'user': sessionData['user']};
      }
    }
    
    return {'success': false, 'error': 'Invalid email or password'};
  }
  
  /// Agency Registration
  static Future<Map<String, dynamic>> agencyRegister(Map<String, dynamic> agencyData) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/auth/agency-register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(agencyData),
      ).timeout(Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          // Auto-login after successful registration
          await saveAgencySession(data);
          return {'success': true, 'user': data['user']};
        } else {
          return {'success': false, 'error': data['message'] ?? 'Registration failed'};
        }
      } else {
        return {'success': false, 'error': 'Server error: ${response.statusCode}'};
      }
    } catch (e) {
      print('❌ Agency registration API error: $e, falling back to local registration');
      
      // Fallback to local registration for testing
      return _localAgencyRegister(agencyData);
    }
  }
  
  /// Local fallback registration for testing
  static Future<Map<String, dynamic>> _localAgencyRegister(Map<String, dynamic> agencyData) async {
    // For testing, just create a session with the provided data
    Map<String, dynamic> sessionData = {
      'session_token': 'local_token_${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        'id': DateTime.now().millisecondsSinceEpoch,
        'email': agencyData['email'],
        'name': agencyData['name'] ?? agencyData['companyName'] ?? 'New Agency',
        'role': USER_ROLE_AGENCY_VALUE, // Use the correct app constant: 'houzez_agency'
        'avatar': '',
      }
    };
    
    await saveAgencySession(sessionData);
    return {'success': true, 'user': sessionData['user']};
  }
  
  /// Guest Login (no authentication required)
  static Future<Map<String, dynamic>> guestLogin() async {
    try {
      await saveGuestSession();
      return {'success': true, 'role': ROLE_GUEST};
    } catch (e) {
      print('❌ Guest login error: $e');
      return {'success': false, 'error': 'Failed to login as guest'};
    }
  }
  
  /// Logout
  static Future<void> logout() async {
    HiveStorageManager.deleteUserLoginInfoData();
    HiveStorageManager.deleteData(key: USER_LOGGED_IN);
    print('✅ User logged out');
  }
  
  /// Get current user role
  static String getCurrentUserRole() {
    return HiveStorageManager.getUserRole();
  }
  
  /// Check if user is logged in
  static bool isLoggedIn() {
    return HiveStorageManager.readData(key: USER_LOGGED_IN) ?? false;
  }
}