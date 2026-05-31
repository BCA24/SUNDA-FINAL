import 'package:flutter/material.dart';import 'package:flutter/material.dart';

import '../../constants/suristay_colors.dart';import '../../constants/suristay_colors.dart';

import 'caribbean_map_placeholder.dart';import 'caribbean_map_placeholder.dart';



class HybridCaribbeanMapScreen extends StatefulWidget {class HybridCaribbeanMapScreen extends StatefulWidget {

  final String? selectedCountry;  final String? selectedCountry;



  const HybridCaribbeanMapScreen({  const HybridCaribbeanMapScreen({

    Key? key,    Key? key,

    this.selectedCountry,    this.selectedCountry,

  }) : super(key: key);  }) : super(key: key);



  @override  @override

  State<HybridCaribbeanMapScreen> createState() => _HybridCaribbeanMapScreenState();  State<HybridCaribbeanMapScreen> createState() => _HybridCaribbeanMapScreenState();

}}



class _HybridCaribbeanMapScreenState extends State<HybridCaribbeanMapScreen> {class _HybridCaribbeanMapScreenState extends State<HybridCaribbeanMapScreen> {

  String? selectedCountry;  String? selectedCountry;



  @override  @override

  void initState() {  void initState() {

    super.initState();    super.initState();

    selectedCountry = widget.selectedCountry;    selectedCountry = widget.selectedCountry;

  }  }

    Future.delayed(Duration(milliseconds: 100), () {

  @override      if (mounted) {

  Widget build(BuildContext context) {        // For now, we'll assume Google Maps works and let it fail gracefully

    return Scaffold(        setState(() {

      backgroundColor: SuriStayColors.darkGreen,          useGoogleMaps = true;

      appBar: AppBar(        });

        backgroundColor: SuriStayColors.darkGreen,      }

        title: Text(    });

          selectedCountry != null   }

              ? '$selectedCountry Properties'

              : 'Caribbean Map',  @override

          style: TextStyle(color: Colors.white),  Widget build(BuildContext context) {

        ),    return Scaffold(

        iconTheme: IconThemeData(color: Colors.white),      backgroundColor: Colors.grey[50],

        actions: [      appBar: AppBar(

          if (selectedCountry != null)        title: Text(

            IconButton(          selectedCountry != null 

              icon: const Icon(Icons.clear),              ? '$selectedCountry Properties'

              onPressed: () => setState(() => selectedCountry = null),              : 'Caribbean Map',

              tooltip: 'Show all countries',          style: TextStyle(

            ),            color: SuriStayColors.darkGreen,

        ],            fontWeight: FontWeight.bold,

      ),          ),

      body: Container(        ),

        color: SuriStayColors.darkGreen,        backgroundColor: Colors.white,

        child: SingleChildScrollView(        elevation: 0,

          padding: const EdgeInsets.all(20),        iconTheme: IconThemeData(color: SuriStayColors.darkGreen),

          child: Column(        actions: [

            crossAxisAlignment: CrossAxisAlignment.start,          // Toggle button to switch between map types

            children: [          IconButton(

              // Info banner            icon: Icon(useGoogleMaps ? Icons.map : Icons.satellite),

              Container(            onPressed: () {

                padding: const EdgeInsets.all(16),              setState(() {

                decoration: BoxDecoration(                useGoogleMaps = !useGoogleMaps;

                  gradient: LinearGradient(              });

                    colors: [            },

                      SuriStayColors.warningOrange.withOpacity(0.2),            tooltip: useGoogleMaps ? 'Switch to Custom Map' : 'Switch to Google Maps',

                      SuriStayColors.turquoise.withOpacity(0.2),          ),

                    ],          if (selectedCountry != null)

                  ),            IconButton(

                  borderRadius: BorderRadius.circular(15),              icon: const Icon(Icons.clear),

                ),              onPressed: () => setState(() => selectedCountry = null),

                child: Row(              tooltip: 'Show all countries',

                  children: [            ),

                    Icon(Icons.map, color: Colors.white),        ],

                    const SizedBox(width: 12),      ),

                    Expanded(      body: useGoogleMaps && !googleMapsError 

                      child: Text(          ? _buildGoogleMapsView()

                        'Caribbean Real Estate Map - Stable & Fast!',          : _buildCustomMapView(),

                        style: TextStyle(    );

                          color: Colors.white,  }

                          fontWeight: FontWeight.w500,

                        ),  Widget _buildGoogleMapsView() {

                      ),    // Create markers for Caribbean countries

                    ),    Set<Marker> markers = {};

                  ],    

                ),    countryCoordinates.forEach((country, coordinates) {

              ),      markers.add(

              const SizedBox(height: 20),        Marker(

                        markerId: MarkerId(country),

              // Caribbean Map          position: coordinates,

              CaribbeanMapPlaceholder(          infoWindow: InfoWindow(

                title: "Caribbean Real Estate Explorer",            title: country,

                height: 400,            snippet: 'Tap to explore properties',

                onCountrySelected: (country) {            onTap: () {

                  setState(() {              setState(() {

                    selectedCountry = selectedCountry == country ? null : country;                selectedCountry = selectedCountry == country ? null : country;

                  });              });

                              },

                  ScaffoldMessenger.of(context).showSnackBar(          ),

                    SnackBar(          icon: selectedCountry == country 

                      content: Text('Exploring properties in $country'),              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)

                      backgroundColor: SuriStayColors.warningOrange,              : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),

                      behavior: SnackBarBehavior.floating,          onTap: () {

                    ),            setState(() {

                  );              selectedCountry = selectedCountry == country ? null : country;

                },            });

              ),          },

                      ),

              if (selectedCountry != null) ...[      );

                const SizedBox(height: 30),    });

                _buildSelectedCountryInfo(),

              ],    // Determine initial camera position

                  LatLng initialPosition = selectedCountry != null && countryCoordinates.containsKey(selectedCountry)

              const SizedBox(height: 30),        ? countryCoordinates[selectedCountry]!

              _buildQuickStats(),        : LatLng(15.0, -70.0); // Caribbean center

            ],

          ),    double initialZoom = selectedCountry != null ? 8.0 : 5.0;

        ),

      ),    return Container(

    );      padding: const EdgeInsets.all(20),

  }      child: Column(

        children: [

  Widget _buildSelectedCountryInfo() {          // Info banner

    return Container(          Container(

      padding: const EdgeInsets.all(20),            padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(            decoration: BoxDecoration(

        gradient: LinearGradient(              gradient: LinearGradient(

          begin: Alignment.topLeft,                colors: [

          end: Alignment.bottomRight,                  SuriStayColors.turquoise.withOpacity(0.1),

          colors: [                  SuriStayColors.warningOrange.withOpacity(0.1),

            Colors.white,                ],

            SuriStayColors.turquoise.withOpacity(0.1),              ),

          ],              borderRadius: BorderRadius.circular(15),

        ),            ),

        borderRadius: BorderRadius.circular(20),            child: Row(

        boxShadow: [              children: [

          BoxShadow(                Icon(Icons.info_outline, color: SuriStayColors.turquoise),

            color: Colors.black.withOpacity(0.1),                const SizedBox(width: 12),

            blurRadius: 15,                Expanded(

            offset: const Offset(0, 5),                  child: Text(

          ),                    'Using Google Maps - Tap markers to explore countries',

        ],                    style: TextStyle(

      ),                      color: SuriStayColors.darkGreen,

      child: Column(                      fontWeight: FontWeight.w500,

        crossAxisAlignment: CrossAxisAlignment.start,                    ),

        children: [                  ),

          Row(                ),

            children: [              ],

              Container(            ),

                width: 50,          ),

                height: 50,          const SizedBox(height: 20),

                decoration: BoxDecoration(          

                  color: SuriStayColors.warningOrange,          // Google Maps

                  borderRadius: BorderRadius.circular(25),          Expanded(

                ),            child: Container(

                child: Center(              decoration: BoxDecoration(

                  child: Text(                borderRadius: BorderRadius.circular(20),

                    selectedCountry?.substring(0, 2).toUpperCase() ?? '',                boxShadow: [

                    style: const TextStyle(                  BoxShadow(

                      color: Colors.white,                    color: Colors.black.withOpacity(0.1),

                      fontSize: 16,                    blurRadius: 15,

                      fontWeight: FontWeight.bold,                    offset: const Offset(0, 5),

                    ),                  ),

                  ),                ],

                ),              ),

              ),              child: ClipRRect(

              const SizedBox(width: 16),                borderRadius: BorderRadius.circular(20),

              Expanded(                child: GoogleMap(

                child: Column(                  initialCameraPosition: CameraPosition(

                  crossAxisAlignment: CrossAxisAlignment.start,                    target: initialPosition,

                  children: [                    zoom: initialZoom,

                    Text(                  ),

                      selectedCountry ?? '',                  markers: markers,

                      style: TextStyle(                  onMapCreated: (GoogleMapController controller) {

                        fontSize: 20,                    // Map created successfully

                        fontWeight: FontWeight.bold,                  },

                        color: SuriStayColors.darkGreen,                  onTap: (LatLng position) {

                      ),                    // Clear selection when tapping empty area

                    ),                    setState(() {

                    Text(                      selectedCountry = null;

                      'Caribbean Paradise',                    });

                      style: TextStyle(                  },

                        fontSize: 14,                  mapType: MapType.normal,

                        color: SuriStayColors.turquoise,                  zoomControlsEnabled: false,

                      ),                  myLocationButtonEnabled: false,

                    ),                  compassEnabled: true,

                  ],                  mapToolbarEnabled: false,

                ),                ),

              ),              ),

            ],            ),

          ),          ),

          const SizedBox(height: 16),          

          Text(          if (selectedCountry != null) ...[

            'Explore beautiful properties in $selectedCountry with stunning beaches, rich culture, and investment opportunities.',            const SizedBox(height: 20),

            style: TextStyle(            _buildSelectedCountryInfo(),

              fontSize: 16,          ],

              color: Colors.grey[700],        ],

              height: 1.4,      ),

            ),    );

          ),  }

          const SizedBox(height: 16),

          ElevatedButton.icon(  Widget _buildCustomMapView() {

            onPressed: () {    return SingleChildScrollView(

              ScaffoldMessenger.of(context).showSnackBar(      padding: const EdgeInsets.all(20),

                SnackBar(      child: Column(

                  content: Text('Loading properties in $selectedCountry...'),        crossAxisAlignment: CrossAxisAlignment.start,

                  backgroundColor: SuriStayColors.warningOrange,        children: [

                ),          // Info banner

              );          Container(

            },            padding: const EdgeInsets.all(16),

            icon: Icon(Icons.search, size: 18),            decoration: BoxDecoration(

            label: Text('Browse Properties'),              gradient: LinearGradient(

            style: ElevatedButton.styleFrom(                colors: [

              backgroundColor: SuriStayColors.warningOrange,                  SuriStayColors.warningOrange.withOpacity(0.1),

              foregroundColor: Colors.white,                  SuriStayColors.turquoise.withOpacity(0.1),

              shape: RoundedRectangleBorder(                ],

                borderRadius: BorderRadius.circular(12),              ),

              ),              borderRadius: BorderRadius.circular(15),

            ),            ),

          ),            child: Row(

        ],              children: [

      ),                Icon(Icons.palette, color: SuriStayColors.warningOrange),

    );                const SizedBox(width: 12),

  }                Expanded(

                  child: Text(

  Widget _buildQuickStats() {                    'Using Custom Caribbean Map - Perfect for emulators!',

    return Container(                    style: TextStyle(

      padding: const EdgeInsets.all(20),                      color: SuriStayColors.darkGreen,

      decoration: BoxDecoration(                      fontWeight: FontWeight.w500,

        color: Colors.white,                    ),

        borderRadius: BorderRadius.circular(20),                  ),

        boxShadow: [                ),

          BoxShadow(              ],

            color: Colors.black.withOpacity(0.1),            ),

            blurRadius: 15,          ),

            offset: const Offset(0, 5),          const SizedBox(height: 20),

          ),          

        ],          // Custom Caribbean Map

      ),          CaribbeanMapWidget(

      child: Column(            selectedCountry: selectedCountry,

        crossAxisAlignment: CrossAxisAlignment.start,            onCountryTap: (country) {

        children: [              setState(() {

          Text(                selectedCountry = selectedCountry == country ? null : country;

            '🏝️ Caribbean Overview',              });

            style: TextStyle(            },

              fontSize: 18,          ),

              fontWeight: FontWeight.bold,          

              color: SuriStayColors.darkGreen,          if (selectedCountry != null) ...[

            ),            const SizedBox(height: 30),

          ),            _buildSelectedCountryInfo(),

          const SizedBox(height: 16),          ],

          Row(          

            children: [          const SizedBox(height: 30),

              Expanded(          _buildQuickStats(),

                child: _buildStatCard('Countries', '14', SuriStayColors.turquoise),        ],

              ),      ),

              const SizedBox(width: 12),    );

              Expanded(  }

                child: _buildStatCard('Properties', '24.8K+', SuriStayColors.warningOrange),

              ),  Widget _buildSelectedCountryInfo() {

            ],    return Container(

          ),      padding: const EdgeInsets.all(20),

          const SizedBox(height: 12),      decoration: BoxDecoration(

          Row(        gradient: LinearGradient(

            children: [          begin: Alignment.topLeft,

              Expanded(          end: Alignment.bottomRight,

                child: _buildStatCard('Avg Price', '\$285K', SuriStayColors.darkGreen),          colors: [

              ),            Colors.white,

              const SizedBox(width: 12),            SuriStayColors.turquoise.withOpacity(0.05),

              Expanded(          ],

                child: _buildStatCard('Islands', '700+', SuriStayColors.turquoise),        ),

              ),        borderRadius: BorderRadius.circular(20),

            ],        boxShadow: [

          ),          BoxShadow(

        ],            color: Colors.black.withOpacity(0.08),

      ),            blurRadius: 15,

    );            offset: const Offset(0, 5),

  }          ),

        ],

  Widget _buildStatCard(String title, String value, Color color) {      ),

    return Container(      child: Column(

      padding: const EdgeInsets.all(16),        crossAxisAlignment: CrossAxisAlignment.start,

      decoration: BoxDecoration(        children: [

        color: color.withOpacity(0.1),          Row(

        borderRadius: BorderRadius.circular(12),            children: [

        border: Border.all(color: color.withOpacity(0.3)),              Container(

      ),                width: 50,

      child: Column(                height: 50,

        crossAxisAlignment: CrossAxisAlignment.start,                decoration: BoxDecoration(

        children: [                  color: SuriStayColors.warningOrange,

          Text(                  borderRadius: BorderRadius.circular(25),

            title,                ),

            style: TextStyle(                child: Center(

              fontSize: 12,                  child: Text(

              color: Colors.grey[600],                    selectedCountry?.substring(0, 2).toUpperCase() ?? '',

              fontWeight: FontWeight.w500,                    style: const TextStyle(

            ),                      color: Colors.white,

          ),                      fontSize: 16,

          const SizedBox(height: 4),                      fontWeight: FontWeight.bold,

          Text(                    ),

            value,                  ),

            style: TextStyle(                ),

              fontSize: 18,              ),

              fontWeight: FontWeight.bold,              const SizedBox(width: 16),

              color: color,              Expanded(

            ),                child: Column(

          ),                  crossAxisAlignment: CrossAxisAlignment.start,

        ],                  children: [

      ),                    Text(

    );                      selectedCountry ?? '',

  }                      style: TextStyle(

}                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: SuriStayColors.darkGreen,
                      ),
                    ),
                    Text(
                      'Caribbean Paradise',
                      style: TextStyle(
                        fontSize: 14,
                        color: SuriStayColors.turquoise,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Explore beautiful properties in $selectedCountry with stunning beaches, rich culture, and investment opportunities.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🏝️ Caribbean Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: SuriStayColors.darkGreen,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Countries', '14', SuriStayColors.turquoise),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Properties', '24.8K+', SuriStayColors.warningOrange),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
