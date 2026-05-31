import 'package:flutter/material.dart';
import '../../constants/suristay_colors.dart';

class RealCaribbeanMap extends StatefulWidget {
  final String? selectedCountry;
  final Function(String)? onCountrySelected;
  final List<dynamic>? properties;
  final double height;

  const RealCaribbeanMap({
    Key? key,
    this.selectedCountry,
    this.onCountrySelected,
    this.properties,
    this.height = 400,
  }) : super(key: key);

  @override
  State<RealCaribbeanMap> createState() => _RealCaribbeanMapState();
}

class _RealCaribbeanMapState extends State<RealCaribbeanMap> {
  String? selectedCountry;

  // Caribbean countries with property counts
  final Map<String, int> caribbeanCountries = {
    'Jamaica': 1240,
    'Bahamas': 890,
    'Barbados': 560,
    'Trinidad and Tobago': 1560,
    'Antigua and Barbuda': 450,
    'Dominica': 320,
    'Grenada': 280,
    'Saint Lucia': 380,
    'Saint Vincent': 220,
    'Belize': 180,
    'Guyana': 340,
    'Suriname': 160,
  };

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.selectedCountry;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: SuriStayColors.darkGreen,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.map, color: Colors.white, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Caribbean Real Estate Map',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Visual Caribbean Map
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF1E3A8A), // Ocean blue
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Ocean background with waves effect
                  Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(0.3, -0.5),
                        radius: 1.2,
                        colors: [
                          Color(0xFF3B82F6), // Lighter blue
                          Color(0xFF1E3A8A), // Darker blue
                        ],
                      ),
                    ),
                  ),
                  
                  // Bahamas (Top center)
                  _buildCountryMarker('Bahamas', 0.5, 0.15),
                  
                  // Cuba representation (Top left)
                  Positioned(
                    left: 20,
                    top: 40,
                    child: Container(
                      width: 80,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Cuba',
                          style: TextStyle(color: Colors.white70, fontSize: 8),
                        ),
                      ),
                    ),
                  ),
                  
                  // Jamaica (Left center)
                  _buildCountryMarker('Jamaica', 0.25, 0.35),
                  
                  // Haiti & Dominican Republic (Center)
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.45,
                    top: 80,
                    child: Container(
                      width: 60,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          'Hispaniola',
                          style: TextStyle(color: Colors.white70, fontSize: 8),
                        ),
                      ),
                    ),
                  ),
                  
                  // Puerto Rico (Right center)
                  Positioned(
                    right: 80,
                    top: 90,
                    child: Container(
                      width: 40,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          'PR',
                          style: TextStyle(color: Colors.white70, fontSize: 8),
                        ),
                      ),
                    ),
                  ),
                  
                  // Lesser Antilles (Right side chain)
                  _buildCountryMarker('Antigua and Barbuda', 0.75, 0.4),
                  _buildCountryMarker('Dominica', 0.78, 0.5),
                  _buildCountryMarker('Saint Lucia', 0.8, 0.6),
                  _buildCountryMarker('Barbados', 0.85, 0.65),
                  _buildCountryMarker('Saint Vincent', 0.82, 0.7),
                  _buildCountryMarker('Grenada', 0.8, 0.8),
                  
                  // Trinidad and Tobago (Bottom right)
                  _buildCountryMarker('Trinidad and Tobago', 0.75, 0.85),
                  
                  // South American coast (Bottom)
                  _buildCountryMarker('Guyana', 0.6, 0.9),
                  _buildCountryMarker('Suriname', 0.7, 0.9),
                  
                  // Belize (Left side)
                  _buildCountryMarker('Belize', 0.15, 0.5),
                  
                  // Compass
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.north, size: 16, color: Colors.red),
                          Text('N', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  
                  // Legend
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: SuriStayColors.turquoise,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text('Countries', style: TextStyle(color: Colors.white, fontSize: 10)),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: SuriStayColors.warningOrange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text('Selected', style: TextStyle(color: Colors.white, fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Footer info
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              selectedCountry != null 
                  ? 'Selected: $selectedCountry (${caribbeanCountries[selectedCountry]} properties)'
                  : 'Tap a country to explore properties',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryMarker(String country, double xPercent, double yPercent) {
    final isSelected = selectedCountry == country;
    final propertyCount = caribbeanCountries[country] ?? 0;
    
    return Positioned(
      left: MediaQuery.of(context).size.width * xPercent - 30,
      top: MediaQuery.of(context).size.height * 0.15 * yPercent,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCountry = selectedCountry == country ? null : country;
          });
          
          if (widget.onCountrySelected != null) {
            widget.onCountrySelected!(selectedCountry ?? '');
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected 
                ? SuriStayColors.warningOrange
                : SuriStayColors.turquoise,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on,
                color: Colors.white,
                size: 14,
              ),
              Text(
                country.length > 8 ? '${country.substring(0, 8)}...' : country,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (isSelected)
                Text(
                  '$propertyCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 7,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}