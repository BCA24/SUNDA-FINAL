import 'dart:convert';

void main() {
  print('Running Simple Property Tests...\n');
  
  var results = [
    testPriceExtraction(),
    testPropertyTypeMapping(),
    testUserIdFallback(),
    testPropertyJsonRoundtrip(),
    testListingTypeDetection(),
  ];
  
  int passed = results.where((r) => r).length;
  int failed = results.length - passed;
  
  print('\n${'=' * 50}\nTEST SUMMARY\n${'=' * 50}');
  print('Passed: $passed | Failed: $failed | Total: ${results.length}');
  print(failed == 0 ? '\nAll tests passed!' : '\nSome tests failed.');
}

// TEST 1: Prijs extractie uit verschillende velden
// Test of prijzen correct worden gelezen uit sale_price, prop_price, floor_plans, etc.
bool testPriceExtraction() {
  print('TEST 1: Price Extraction\n${'─' * 50}');
  try {
    _assert(extractPrice({'sale_price': 450000}) == 450000);
    _assert(extractPrice({'prop_price': '325000'}) == 325000);
    _assert(extractPrice({'price': '\$750,000 USD'}) == 750000);
    _assert(extractPrice({'floor_plans': [{'fave_plan_price': '550000'}]}) == 550000);
    _assert(extractPrice({'title': 'No price'}) == 0);
    print('PASSED\n');
    return true;
  } catch (e) {
    print('FAILED: $e\n');
    return false;
  }
}

// TEST 2: Property type normalisatie
// Test of property types correct worden omgezet naar lowercase en juiste veld wordt gebruikt
bool testPropertyTypeMapping() {
  print('TEST 2: Property Type Mapping\n${'─' * 50}');
  try {
    _assert(extractPropertyType({'property_type': 'VILLA'}) == 'villa');
    _assert(extractPropertyType({'fave_property_type': 'Apartment'}) == 'apartment');
    _assert(extractPropertyType({'property_type': 'Land', 'fave_property_type': 'House'}) == 'land');
    _assert(extractPropertyType({'title': 'Property'}) == 'house');
    print('PASSED\n');
    return true;
  } catch (e) {
    print('FAILED: $e\n');
    return false;
  }
}

// TEST 3: User ID validatie met admin fallback
// Test of lege user_id correct terugvalt op admin UUID (belangrijk voor database constraints)
bool testUserIdFallback() {
  print('TEST 3: User ID Fallback\n${'─' * 50}');
  try {
    String admin = '550e8400-e29b-41d4-a716-446655440000';
    String valid = '123e4567-e89b-12d3-a456-426614174000';
    _assert(validateUserId(valid) == valid);
    _assert(validateUserId('') == admin);
    _assert(validateUserId('').isNotEmpty);
    print('PASSED\n');
    return true;
  } catch (e) {
    print('FAILED: $e\n');
    return false;
  }
}

// TEST 4: JSON serialisatie roundtrip
// Test of property data geen informatie verliest bij encode/decode cyclus
bool testPropertyJsonRoundtrip() {
  print('TEST 4: JSON Serialization\n${'─' * 50}');
  try {
    var prop = {'id': 'prop123', 'title': 'Villa', 'sale_price': 1250000, 'bedrooms': 4, 'furnished': true};
    String json = jsonEncode(prop);
    var decoded = jsonDecode(json);
    _assert(json.contains('Villa'));
    _assert(decoded['title'] == 'Villa');
    _assert(decoded['sale_price'] == 1250000);
    _assert(decoded['furnished'] == true);
    print('PASSED\n');
    return true;
  } catch (e) {
    print('FAILED: $e\n');
    return false;
  }
}

// TEST 5: Listing type detectie uit property status
// Test of sale/rent/lease correct wordt gedetecteerd op basis van status keywords
bool testListingTypeDetection() {
  print('TEST 5: Listing Type Detection\n${'─' * 50}');
  try {
    _assert(extractListingType({'property_status': 'For Sale'}) == 'sale');
    _assert(extractListingType({'property_status': 'For Rent - Monthly'}) == 'rent');
    _assert(extractListingType({'property_status': 'Long-term Lease'}) == 'lease');
    _assert(extractListingType({'fave_property_status': 'For Rent'}) == 'rent');
    _assert(extractListingType({'property_status': 'Pending'}) == 'sale');
    print('PASSED\n');
    return true;
  } catch (e) {
    print('FAILED: $e\n');
    return false;
  }
}

// Helper functies
void _assert(bool condition, [String msg = 'Assertion failed']) {
  if (!condition) throw Exception(msg);
}

int extractPrice(Map<String, dynamic> data) {
  for (var key in ['sale_price', 'fave_property_price', 'prop_price', 'price']) {
    if (data.containsKey(key)) {
      try {
        return int.parse(data[key].toString().replaceAll(RegExp(r'[^0-9]'), ''));
      } catch (_) {}
    }
  }
  if (data['floor_plans'] is List && (data['floor_plans'] as List).isNotEmpty) {
    var plan = data['floor_plans'][0];
    if (plan is Map && plan['fave_plan_price'] != null) {
      try {
        return int.parse(plan['fave_plan_price'].toString().replaceAll(RegExp(r'[^0-9]'), ''));
      } catch (_) {}
    }
  }
  return 0;
}

String extractPropertyType(Map<String, dynamic> data) {
  if (data.containsKey('property_type')) return data['property_type'].toString().toLowerCase();
  if (data.containsKey('fave_property_type')) return data['fave_property_type'].toString().toLowerCase();
  return 'house';
}

String validateUserId(String userId) {
  return userId.isEmpty ? '550e8400-e29b-41d4-a716-446655440000' : userId;
}

String extractListingType(Map<String, dynamic> data) {
  for (var key in ['property_status', 'fave_property_status']) {
    if (data.containsKey(key)) {
      String status = data[key].toString().toLowerCase();
      if (status.contains('rent')) return 'rent';
      if (status.contains('lease')) return 'lease';
    }
  }
  return 'sale';
}