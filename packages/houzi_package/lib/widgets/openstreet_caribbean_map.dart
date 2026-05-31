import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../constants/suristay_colors.dart';

class OpenStreetCaribbeanMap extends StatefulWidget {
  final String? selectedCountry;
  final Function(String)? onCountrySelected;
  final List<dynamic>? properties;
  final double height;

  const OpenStreetCaribbeanMap({
    Key? key,
    this.selectedCountry,
    this.onCountrySelected,
    this.properties,
    this.height = 400,
  }) : super(key: key);

  @override
  State<OpenStreetCaribbeanMap> createState() => _OpenStreetCaribbeanMapState();
}

class _OpenStreetCaribbeanMapState extends State<OpenStreetCaribbeanMap> {
  late MapController _mapController;
  String? selectedCountry;

  // Caribbean region center coordinates
  static const LatLng caribbeanCenter = LatLng(18.0, -75.0);
  
  // Caribbean countries with their coordinates and property counts
  final Map<String, Map<String, dynamic>> caribbeanCountries = {
    'Jamaica': {
      'coordinates': LatLng(18.1096, -77.2975),
      'properties': 1240,
      'capital': 'Kingston'
    },
    'Bahamas': {
      'coordinates': LatLng(25.0343, -77.3963),
      'properties': 890,
      'capital': 'Nassau'
    },
    'Barbados': {
      'coordinates': LatLng(13.1939, -59.5432),
      'properties': 560,
      'capital': 'Bridgetown'
    },
    'Trinidad and Tobago': {
      'coordinates': LatLng(10.6918, -61.2225),
      'properties': 1560,
      'capital': 'Port of Spain'
    },
    'Antigua and Barbuda': {
      'coordinates': LatLng(17.0608, -61.7964),
      'properties': 450,
      'capital': 'St. John\'s'
    },
    'Dominica': {
      'coordinates': LatLng(15.4150, -61.3710),
      'properties': 320,
      'capital': 'Roseau'
    },
    'Grenada': {
      'coordinates': LatLng(12.1165, -61.6790),
      'properties': 280,
      'capital': 'St. George\'s'
    },
    'Saint Lucia': {
      'coordinates': LatLng(13.9094, -60.9789),
      'properties': 380,
      'capital': 'Castries'
    },
    'Saint Vincent and the Grenadines': {
      'coordinates': LatLng(12.9843, -61.2872),
      'properties': 220,
      'capital': 'Kingstown'
    },
    'Belize': {
      'coordinates': LatLng(17.1899, -88.4976),
      'properties': 180,
      'capital': 'Belmopan'
    },
    'Guyana': {
      'coordinates': LatLng(4.8604, -58.9302),
      'properties': 340,
      'capital': 'Georgetown'
    },
    'Suriname': {
      'coordinates': LatLng(3.9193, -56.0278),
      'properties': 160,
      'capital': 'Paramaribo'
    },
    'Dominican Republic': {
      'coordinates': LatLng(18.7357, -70.1627),
      'properties': 980,
      'capital': 'Santo Domingo'
    },
    'Haiti': {
      'coordinates': LatLng(18.9712, -72.2852),
      'properties': 120,
      'capital': 'Port-au-Prince'
    },
    'Cuba': {
      'coordinates': LatLng(21.5218, -77.7812),
      'properties': 450,
      'capital': 'Havana'
    },
    'Puerto Rico': {
      'coordinates': LatLng(18.2208, -66.5901),
      'properties': 720,
      'capital': 'San Juan'
    },
  };

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
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
          // Header with controls
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
                // Map controls
                Row(
                  children: [
                    IconButton(
                      onPressed: _zoomIn,
                      icon: Icon(Icons.zoom_in, color: Colors.white),
                      iconSize: 20,
                      tooltip: 'Zoom In',
                    ),
                    IconButton(
                      onPressed: _zoomOut,
                      icon: Icon(Icons.zoom_out, color: Colors.white),
                      iconSize: 20,
                      tooltip: 'Zoom Out',
                    ),
                    IconButton(
                      onPressed: _resetView,
                      icon: Icon(Icons.center_focus_strong, color: Colors.white),
                      iconSize: 20,
                      tooltip: 'Reset View',
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // OpenStreetMap
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: caribbeanCenter,
                    initialZoom: 6.0,
                    minZoom: 4.0,
                    maxZoom: 18.0,
                    interactionOptions: InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                  ),
                  children: [
                    // OpenStreetMap tile layer
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.houzi.app',
                      maxZoom: 18,
                    ),
                    
                    // Country markers
                    MarkerLayer(
                      markers: _buildCountryMarkers(),
                    ),
                    
                    // Attribution layer (required for OpenStreetMap)
                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Footer info
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                if (selectedCountry != null) ...[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: SuriStayColors.turquoise.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on, 
                             color: SuriStayColors.turquoise, size: 16),
                        SizedBox(width: 8),
                        Text(
                          '$selectedCountry - ${caribbeanCountries[selectedCountry]!['properties']} properties',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                ],
                Text(
                  selectedCountry == null 
                      ? 'Tap a marker to explore properties • Pinch to zoom • Drag to pan'
                      : 'Capital: ${caribbeanCountries[selectedCountry]!['capital']}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Marker> _buildCountryMarkers() {
    return caribbeanCountries.entries.map((entry) {
      final country = entry.key;
      final data = entry.value;
      final coordinates = data['coordinates'] as LatLng;
      final properties = data['properties'] as int;
      final isSelected = selectedCountry == country;
      
      return Marker(
        point: coordinates,
        width: 60,
        height: 60,
        child: GestureDetector(
          onTap: () => _onCountryTapped(country),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected 
                  ? SuriStayColors.warningOrange
                  : SuriStayColors.turquoise,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 18,
                ),
                Text(
                  properties > 999 
                      ? '${(properties / 1000).toStringAsFixed(1)}k'
                      : properties.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  void _onCountryTapped(String country) {
    setState(() {
      selectedCountry = selectedCountry == country ? null : country;
    });
    
    if (selectedCountry != null) {
      // Animate to the selected country
      final coordinates = caribbeanCountries[selectedCountry]!['coordinates'] as LatLng;
      _mapController.move(coordinates, 8.0);
    }
    
    if (widget.onCountrySelected != null) {
      widget.onCountrySelected!(selectedCountry ?? '');
    }
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom + 1);
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom - 1);
  }

  void _resetView() {
    _mapController.move(caribbeanCenter, 6.0);
    setState(() {
      selectedCountry = null;
    });
  }
}
