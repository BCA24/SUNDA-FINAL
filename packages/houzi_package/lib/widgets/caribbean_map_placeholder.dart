import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';

class CaribbeanMapPlaceholder extends StatefulWidget {
  final String title;
  final double? height;
  final Function(String country)? onCountrySelected;
  
  const CaribbeanMapPlaceholder({
    super.key,
    this.title = "Caribbean Region Map",
    this.height,
    this.onCountrySelected,
  });

  @override
  State<CaribbeanMapPlaceholder> createState() => _CaribbeanMapPlaceholderState();
}

class _CaribbeanMapPlaceholderState extends State<CaribbeanMapPlaceholder> {
  String? selectedCountry;

  final List<Map<String, dynamic>> caribbeanCountries = [
    {'name': 'Jamaica', 'properties': 45, 'top': 60.0, 'left': 80.0, 'width': 40.0, 'height': 25.0, 'avgPrice': '\$250K', 'type': 'Beachfront Villas'},
    {'name': 'Barbados', 'properties': 28, 'top': 40.0, 'right': 60.0, 'width': 20.0, 'height': 15.0, 'avgPrice': '\$380K', 'type': 'Luxury Condos'},
    {'name': 'Trinidad', 'properties': 32, 'top': 100.0, 'left': 150.0, 'width': 35.0, 'height': 20.0, 'avgPrice': '\$180K', 'type': 'Family Homes'},
    {'name': 'Suriname', 'properties': 19, 'top': 80.0, 'right': 100.0, 'width': 50.0, 'height': 30.0, 'avgPrice': '\$120K', 'type': 'Riverfront Properties'},
    {'name': 'Bahamas', 'properties': 38, 'top': 30.0, 'left': 50.0, 'width': 30.0, 'height': 20.0, 'avgPrice': '\$450K', 'type': 'Resort Properties'},
    {'name': 'Guyana', 'properties': 15, 'top': 120.0, 'left': 200.0, 'width': 45.0, 'height': 35.0, 'avgPrice': '\$95K', 'type': 'Eco-Lodges'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 300,
      decoration: BoxDecoration(
        color: const Color(0xFF006633), // Caribbean dark green
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFFFAC00), // Caribbean orange
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          // Background gradient to simulate ocean
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF2EC4B6), // Caribbean turquoise
                  const Color(0xFF006633), // Caribbean dark green
                ],
              ),
            ),
          ),
          // Caribbean islands with click interaction
          ...caribbeanCountries.map((country) => _buildInteractiveIsland(country)).toList(),
          
          // Title
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // Property counter for selected country
          if (selectedCountry != null)
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFAC00), // Caribbean orange
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedCountry!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.home, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${_getCountryProperties(selectedCountry!)} properties',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Avg: ${_getCountryAvgPrice(selectedCountry!)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      _getCountryPropertyType(selectedCountry!),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Center overlay message (only when no country selected)
          if (selectedCountry == null)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.touch_app,
                      color: Color(0xFFFFAC00), // Caribbean orange
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Caribbean Real Estate",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Tap on any island to view properties",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInteractiveIsland(Map<String, dynamic> country) {
    bool isSelected = selectedCountry == country['name'];
    
    return Positioned(
      top: country['top'],
      left: country.containsKey('left') ? country['left'] : null,
      right: country.containsKey('right') ? country['right'] : null,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCountry = isSelected ? null : country['name'];
          });
          if (widget.onCountrySelected != null) {
            widget.onCountrySelected!(country['name']);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: country['width'] * (isSelected ? 1.2 : 1.0),
          height: country['height'] * (isSelected ? 1.2 : 1.0),
          decoration: BoxDecoration(
            color: isSelected 
                ? const Color(0xFFFFAC00) // Caribbean orange when selected
                : const Color(0xFF2EC4B6), // Caribbean turquoise when not selected
            borderRadius: BorderRadius.circular(8),
            border: isSelected 
                ? Border.all(color: Colors.white, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: const Offset(2, 2),
                blurRadius: isSelected ? 8 : 4,
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  country['name'],
                  style: TextStyle(
                    fontSize: isSelected ? 10 : 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (isSelected) ...[
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.home, color: Colors.white, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        '${country['properties']}',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _getCountryProperties(String countryName) {
    final country = caribbeanCountries.firstWhere(
      (c) => c['name'] == countryName,
      orElse: () => {'properties': 0},
    );
    return country['properties'] ?? 0;
  }

  String _getCountryAvgPrice(String countryName) {
    final country = caribbeanCountries.firstWhere(
      (c) => c['name'] == countryName,
      orElse: () => {'avgPrice': 'N/A'},
    );
    return country['avgPrice'] ?? 'N/A';
  }

  String _getCountryPropertyType(String countryName) {
    final country = caribbeanCountries.firstWhere(
      (c) => c['name'] == countryName,
      orElse: () => {'type': 'Properties'},
    );
    return country['type'] ?? 'Properties';
  }
}