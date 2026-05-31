import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:houzi_package/models/article.dart';
import 'constants/suristay_colors.dart';
import 'widgets/caribbean_painters.dart';
import 'widgets/caricom_explorer_carousel.dart';
import 'widgets/caribbean_property_filter.dart';
import 'pages/caribbean_map_page.dart';
import 'services/caribbean_api_service.dart';

class CaricomRegionMainPage extends StatefulWidget {
  @override
  _CaricomRegionMainPageState createState() {
    print('🏗️ Creating CaricomRegionMainPage state...');
    return _CaricomRegionMainPageState();
  }
}

class _CaricomRegionMainPageState extends State<CaricomRegionMainPage> {
  String selectedRegion = 'West';
  List<Article> properties = [];
  bool isLoadingProperties = false;
  bool apiConnectionStatus = false;
  
  @override
  void initState() {
    super.initState();
    print('🏝️ CARICOM REGION MAIN PAGE INITIALIZING...');
    _initializeApp();
  }
  
  // Initialize app and test API connection
  Future<void> _initializeApp() async {
    print('🔧 Testing API connection...');
    await _testApiConnection();
    print('📋 Loading properties...');
    await _loadProperties();
  }
  
  // Test API connection
  Future<void> _testApiConnection() async {
    setState(() {
      isLoadingProperties = true;
    });
    
    await CaribbeanApiService.showConnectionStatus();
    final isConnected = await CaribbeanApiService.testConnection();
    
    setState(() {
      apiConnectionStatus = isConnected;
    });

    // If API is connected, load real properties from database
    if (isConnected) {
      await _loadPropertiesFromDatabase();
    } else {
      // If API is not available, load mockup data for testing
      await _loadMockupProperties();
    }
  }

  // Load real properties from PostgreSQL database
  Future<void> _loadPropertiesFromDatabase() async {
    try {
      print('🔄 Loading properties from PostgreSQL database...');
      final dbProperties = await CaribbeanApiService.fetchProperties();
      
      setState(() {
        properties = dbProperties;
        isLoadingProperties = false;
      });
      
      print('✅ Loaded ${properties.length} properties from database');
    } catch (e) {
      print('❌ Error loading properties from database: $e');
      await _loadMockupProperties();
    }
  }

  // Load mockup Caribbean properties when API is unavailable
  Future<void> _loadMockupProperties() async {
    setState(() {
      properties = _generateMockupCaribbeanProperties();
      isLoadingProperties = false;
    });
    print('🏝️ Loaded ${properties.length} mockup Caribbean properties for offline testing');
  }

  // Generate sample Caribbean properties for offline testing
  List<Article> _generateMockupCaribbeanProperties() {
    final mockupProperties = <Article>[];

    // Property 1 - Beachfront Villa in Barbados
    final property1 = Article(
      id: 1,
      title: 'Beautiful Beachfront Villa - Barbados',
      content: 'Stunning oceanfront property with 4 bedrooms, infinity pool, and private beach access. Perfect for vacation rental or permanent residence.',
      imageList: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800'],
      status: 'For Sale',
    );
    
    // Set property info for property 1
    property1.propertyInfo = PropertyInfo(
      price: '850000',
      priceDisplay: '\$850,000 BBD',
      currency: 'BBD',
      propertyStatus: 'For Sale',
    );
    
    property1.propertyFeatures = Features(
      bedrooms: '4',
      bathrooms: '3',
      propertyArea: '3200',
      propertyAreaUnit: 'sq ft',
    );
    
    property1.propertyAddress = Address(
      city: 'Bridgetown',
      country: 'Barbados',
      address: 'St. Lawrence Gap, Barbados',
      state: 'Christ Church',
    );
    
    property1.propertyDetailsMap = {
      'PRICE': '850000',
      'property_type': 'Villa',
      'property_status': 'For Sale',
    };
    
    mockupProperties.add(property1);

    // Property 2 - Modern Apartment in Jamaica
    final property2 = Article(
      id: 2,
      title: 'Modern Apartment - Kingston, Jamaica',
      content: 'Contemporary 2-bedroom apartment in upscale New Kingston area with city views and modern amenities.',
      imageList: ['https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800'],
      status: 'For Sale',
    );
    
    property2.propertyInfo = PropertyInfo(
      price: '45000000',
      priceDisplay: 'J\$45,000,000',
      currency: 'JMD',
      propertyStatus: 'For Sale',
    );
    
    property2.propertyFeatures = Features(
      bedrooms: '2',
      bathrooms: '2',
      propertyArea: '1100',
      propertyAreaUnit: 'sq ft',
    );
    
    property2.propertyAddress = Address(
      city: 'Kingston',
      country: 'Jamaica',
      address: 'New Kingston, Kingston',
      state: 'Kingston',
    );
    
    property2.propertyDetailsMap = {
      'PRICE': '45000000',
      'property_type': 'Apartment',
      'property_status': 'For Sale',
    };
    
    mockupProperties.add(property2);

    // Property 3 - Tropical Resort in Trinidad
    final property3 = Article(
      id: 3,
      title: 'Tropical Resort Property - Trinidad',
      content: 'Exclusive resort-style property with multiple buildings, pool complex, and stunning mountain views.',
      imageList: ['https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800'],
      status: 'For Sale',
    );
    
    property3.propertyInfo = PropertyInfo(
      price: '2500000',
      priceDisplay: 'TT\$2,500,000',
      currency: 'TTD',
      propertyStatus: 'For Sale',
    );
    
    property3.propertyFeatures = Features(
      bedrooms: '8',
      bathrooms: '6',
      propertyArea: '8500',
      propertyAreaUnit: 'sq ft',
    );
    
    property3.propertyAddress = Address(
      city: 'Port of Spain',
      country: 'Trinidad & Tobago',
      address: 'Maraval, Port of Spain',
      state: 'Port of Spain',
    );
    
    property3.propertyDetailsMap = {
      'PRICE': '2500000',
      'property_type': 'Resort',
      'property_status': 'For Sale',
    };
    
    mockupProperties.add(property3);

    // Property 4 - Luxury Condo in Bahamas
    final property4 = Article(
      id: 4,
      title: 'Luxury Condo - Nassau, Bahamas',
      content: 'High-end condominium with marina access, 24/7 security, and resort amenities. Prime location in Cable Beach area.',
      imageList: ['https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=800'],
      status: 'For Sale',
    );
    
    property4.propertyInfo = PropertyInfo(
      price: '675000',
      priceDisplay: '\$675,000 BSD',
      currency: 'BSD',
      propertyStatus: 'For Sale',
    );
    
    property4.propertyFeatures = Features(
      bedrooms: '3',
      bathrooms: '2',
      propertyArea: '1850',
      propertyAreaUnit: 'sq ft',
    );
    
    property4.propertyAddress = Address(
      city: 'Nassau',
      country: 'Bahamas',
      address: 'Cable Beach, Nassau',
      state: 'New Providence',
    );
    
    property4.propertyDetailsMap = {
      'PRICE': '675000',
      'property_type': 'Condominium',
      'property_status': 'For Sale',
    };
    
    mockupProperties.add(property4);

    // Property 5 - Plantation House in St. Lucia
    final property5 = Article(
      id: 5,
      title: 'Plantation House - St. Lucia',
      content: 'Historic plantation house fully renovated with modern comforts. Set on 5 acres with tropical gardens.',
      imageList: ['https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800'],
      status: 'For Sale',
    );
    
    property5.propertyInfo = PropertyInfo(
      price: '1250000',
      priceDisplay: 'EC\$1,250,000',
      currency: 'XCD',
      propertyStatus: 'For Sale',
    );
    
    property5.propertyFeatures = Features(
      bedrooms: '6',
      bathrooms: '4',
      propertyArea: '4200',
      propertyAreaUnit: 'sq ft',
    );
    
    property5.propertyAddress = Address(
      city: 'Soufrière',
      country: 'St. Lucia',
      address: 'Soufrière, St. Lucia',
      state: 'Soufrière District',
    );
    
    property5.propertyDetailsMap = {
      'PRICE': '1250000',
      'property_type': 'House',
      'property_status': 'For Sale',
    };
    
    mockupProperties.add(property5);

    return mockupProperties;
  }
  
  // Load properties from local PostgreSQL database
  Future<void> _loadProperties() async {
    print('🔄 _loadProperties() starting...');
    setState(() {
      isLoadingProperties = true;
    });
    
    try {
      print('📞 Calling CaribbeanApiService.fetchProperties...');
      final fetchedProperties = await CaribbeanApiService.fetchProperties(
        limit: 10, // Load 10 properties initially
      );
      
      print('📦 Received ${fetchedProperties.length} properties from API');
      setState(() {
        properties = fetchedProperties;
        isLoadingProperties = false;
      });
      
      if (fetchedProperties.isNotEmpty) {
        print('✅ Successfully loaded ${fetchedProperties.length} properties from database');
      } else {
        print('⚠️ No properties found in database');
      }
    } catch (e) {
      print('❌ Error loading properties: $e');
      setState(() {
        isLoadingProperties = false;
      });
    }
  }
  
  // Load filtered properties based on region or filter criteria
  Future<void> _loadFilteredProperties({
    String? country,
    String? propertyType,
    int? minBedrooms,
    int? maxBedrooms,
    double? minPrice,
    double? maxPrice,
  }) async {
    setState(() {
      isLoadingProperties = true;
    });
    
    try {
      final filteredProperties = await CaribbeanApiService.fetchProperties(
        country: country,
        propertyType: propertyType,
        minBedrooms: minBedrooms,
        maxBedrooms: maxBedrooms,
        minPrice: minPrice,
        maxPrice: maxPrice,
        limit: 20,
      );
      
      setState(() {
        properties = filteredProperties;
        isLoadingProperties = false;
      });
      
      print('🔍 Loaded ${filteredProperties.length} filtered properties');
    } catch (e) {
      print('❌ Error loading filtered properties: $e');
      setState(() {
        isLoadingProperties = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section - SunStay Caribbean
                _buildSunStayHeader(),
                
                // Search Section
                _buildSearchSection(),
                
                // CARICOM Explorer Carousel
                CaricomExplorerCarousel(
                  onCountrySelected: (String countryName) {
                    print('Selected country: $countryName');
                    // Handle country selection
                  },
                  onRegionExplored: (String regionId) {
                    print('Exploring region: $regionId');
                    // Handle region exploration
                  },
                ),
                
                // Property Filter Section - Connected to PostgreSQL
                CaribbeanPropertyFilter(
                  onFiltersChanged: (criteria) {
                    print('Filter applied: $criteria');
                    // Apply filters to load properties from database
                    _loadFilteredProperties(
                      propertyType: criteria.propertyType,
                      minBedrooms: criteria.bedrooms,
                      minPrice: criteria.minPrice,
                      maxPrice: criteria.maxPrice,
                    );
                  },
                ),
                
                // Real Properties from PostgreSQL Database
                _buildDatabasePropertiesSection(),
                
                // Region Tabs (West/East/Mainland)
                _buildRegionTabs(),
                
                // Dynamic Caribbean Properties Section
                _buildCaribbeanSection(),
                
                // Bottom Navigation Space
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSunStayHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: SuriStayColors.caribbeanSunset,
      ),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          // SuriStay Logo
          Image.asset('assets/icon/suristay_logo.png', height: 40),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SuriStay',
                  style: GoogleFonts.montserrat(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Caribbean',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: SuriStayColors.brightYellow,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Tropical accent
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: SuriStayColors.brightYellow.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.wb_sunny,
              color: SuriStayColors.brightYellow,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: SuriStayColors.darkGreen.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: SuriStayColors.deepTeal,
              ),
              decoration: InputDecoration(
                hintText: 'Discover your Caribbean paradise...',
                hintStyle: GoogleFonts.openSans(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
                suffixIcon: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: SuriStayColors.vibrantAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onSubmitted: (value) {
                _navigateToSearch(value);
              },
            ),
          ),
          
          SizedBox(height: 16),
          
          // Map Button
          Container(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CaribbeanMapPage(),
                  ),
                );
              },
              icon: Icon(Icons.map, color: Colors.white),
              label: Text(
                'View Caribbean Properties Map',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: SuriStayColors.darkGreen,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionTabs() {
    List<String> regions = ['West', 'East', 'Mainland'];
    
    return Container(
      height: 55,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: regions.map((region) {
          bool isSelected = selectedRegion == region;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedRegion = region;
                });
                HapticFeedback.lightImpact();
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  gradient: isSelected 
                    ? SuriStayColors.caribbeanSunset
                    : null,
                  color: isSelected ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected 
                      ? SuriStayColors.darkGreen 
                      : SuriStayColors.warmGray,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: SuriStayColors.darkGreen.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ] : null,
                ),
                child: Center(
                  child: Text(
                    region,
                    style: GoogleFonts.montserrat(
                      color: isSelected ? Colors.white : SuriStayColors.deepTeal,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCaribbeanSection() {
    // Dynamic title based on selected region
    String regionTitle = selectedRegion == 'West' 
        ? 'Western Caribbean'
        : selectedRegion == 'East' 
            ? 'Eastern Caribbean'
            : 'Caribbean Mainland';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  regionTitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: SuriStayColors.deepTeal,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: SuriStayColors.tropicalParadise,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Premium',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildCaribbeanDestinationsGrid(),
      ],
    );
  }

  Widget _buildCaribbeanDestinationsGrid() {
    // Different destinations based on selected region
    Map<String, List<Map<String, dynamic>>> regionDestinations = {
      'West': [
        {
          'name': 'Bahamas',
          'properties': '47 properties',
          'color': SuriStayColors.turquoise,
        },
        {
          'name': 'Jamaica',
          'properties': '23 properties',
          'color': SuriStayColors.successGreen,
        },
        {
          'name': 'Trinidad',
          'properties': '31 properties',
          'color': SuriStayColors.darkGreen,
        },
        {
          'name': 'Barbados',
          'properties': '16 properties',
          'color': SuriStayColors.vibrantRed,
        },
        {
          'name': 'Dominica',
          'properties': 'Coming soon',
          'color': Colors.grey[400]!,
        },
        {
          'name': 'St. Lucia',
          'properties': '12 properties',
          'color': SuriStayColors.warningOrange,
        },
      ],
      'East': [
        {
          'name': 'Antigua',
          'properties': '18 properties',
          'color': SuriStayColors.successGreen,
        },
        {
          'name': 'St. Kitts',
          'properties': '9 properties',
          'color': SuriStayColors.vibrantRed,
        },
        {
          'name': 'Martinique',
          'properties': '15 properties',
          'color': SuriStayColors.darkGreen,
        },
        {
          'name': 'Guadeloupe',
          'properties': '22 properties',
          'color': SuriStayColors.warningOrange,
        },
        {
          'name': 'St. Vincent',
          'properties': '7 properties',
          'color': SuriStayColors.turquoise,
        },
        {
          'name': 'Grenada',
          'properties': 'Coming soon',
          'color': Colors.grey[400]!,
        },
      ],
      'Mainland': [
        {
          'name': 'Belize',
          'properties': '34 properties',
          'color': SuriStayColors.successGreen,
        },
        {
          'name': 'Guyana',
          'properties': '19 properties',
          'color': SuriStayColors.darkGreen,
        },
        {
          'name': 'Suriname',
          'properties': '11 properties',
          'color': SuriStayColors.vibrantRed,
        },
        {
          'name': 'Fr. Guiana',
          'properties': '8 properties',
          'color': SuriStayColors.warningOrange,
        },
        {
          'name': 'Venezuela',
          'properties': 'Coming soon',
          'color': Colors.grey[400]!,
        },
        {
          'name': 'Colombia',
          'properties': '25 properties',
          'color': SuriStayColors.turquoise,
        },
      ],
    };
    
    List<Map<String, dynamic>> destinations = regionDestinations[selectedRegion] ?? regionDestinations['West']!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          final destination = destinations[index];
          bool isComingSoon = destination['properties'] == 'Coming soon';
          
          return GestureDetector(
            onTap: isComingSoon ? null : () {
              HapticFeedback.lightImpact();
              _navigateToPropertiesByDestination(destination);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: SuriStayColors.darkGreen.withOpacity(0.08),
                    spreadRadius: 1,
                    blurRadius: 15,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Caribbean-style illustration container
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: destination['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: CustomPaint(
                      painter: CaribbeanPropertyPainter(
                        destination['color'],
                        propertyType: _getPropertyType(destination['name']),
                      ),
                      child: Container(),
                    ),
                  ),
                  // Content section
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            destination['name'],
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: SuriStayColors.deepTeal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 6),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isComingSoon 
                                ? Colors.grey[300]
                                : destination['color'],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              destination['properties'],
                              style: GoogleFonts.openSans(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getCountryIcon(String countryName) {
    switch (countryName.toLowerCase()) {
      // West Caribbean
      case 'bahamas':
        return Icons.waves;
      case 'jamaica':
        return Icons.beach_access;
      case 'trinidad':
        return Icons.landscape;
      case 'barbados':
        return Icons.sailing;
      case 'dominica':
        return Icons.eco;
      case 'st. lucia':
        return Icons.flag;
      
      // East Caribbean  
      case 'antigua':
        return Icons.landscape;
      case 'st. kitts':
        return Icons.terrain;
      case 'martinique':
        return Icons.local_florist;
      case 'guadeloupe':
        return Icons.park;
      case 'st. vincent':
        return Icons.nature;
      case 'grenada':
        return Icons.forest;
      
      // Mainland Caribbean
      case 'belize':
        return Icons.forest;
      case 'guyana':
        return Icons.nature_people;
      case 'suriname':
        return Icons.eco;
      case 'fr. guiana':
        return Icons.park;
      case 'venezuela':
        return Icons.landscape;
      case 'colombia':
        return Icons.terrain;
      
      default:
        return Icons.location_on;
    }
  }

  String _getPropertyType(String countryName) {
    switch (countryName.toLowerCase()) {
      // Beach destinations
      case 'bahamas':
      case 'barbados':
      case 'antigua':
        return 'beach';
      
      // Luxury destinations
      case 'st. lucia':
      case 'st. kitts':
      case 'martinique':
        return 'luxury';
      
      // Mountain/nature destinations
      case 'dominica':
      case 'grenada':
      case 'st. vincent':
        return 'villa';
      
      // Urban/apartment destinations
      case 'trinidad':
      case 'guadeloupe':
      case 'colombia':
        return 'apartment';
      
      // Default tropical house
      default:
        return 'house';
    }
  }

  void _navigateToPropertiesByDestination(Map<String, dynamic> destination) {
    // Navigate to property listings - you can customize this
    print('Navigating to ${destination['name']} properties');
  }

  void _navigateToSearch(String query) {
    // Navigate to search - you can customize this
    print('Searching for: $query');
  }

  
  // Build Database Properties Section
  Widget _buildDatabasePropertiesSection() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Icon(
                Icons.storage,
                color: SuriStayColors.deepTeal,
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Live Properties',
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: SuriStayColors.deepTeal,
                  ),
                ),
              ),
              // Connection Status Indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: apiConnectionStatus ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      apiConnectionStatus ? Icons.wifi : Icons.wifi_off,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      apiConnectionStatus ? 'Connected' : 'Offline',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          // Loading State
          if (isLoadingProperties)
            Container(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: SuriStayColors.deepTeal,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading properties from database...',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: SuriStayColors.deepTeal,
                      ),
                    ),
                  ],
                ),
              ),
            )
          
          // Properties List
          else if (properties.isNotEmpty)
            Container(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  final property = properties[index];
                  return _buildPropertyCard(property);
                },
              ),
            )
          
          // Empty State
          else
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 12),
                    Text(
                      apiConnectionStatus 
                        ? 'No properties found in database'
                        : 'Database connection unavailable',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    if (!apiConnectionStatus)
                      ElevatedButton(
                        onPressed: _initializeApp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SuriStayColors.deepTeal,
                        ),
                        child: Text(
                          'Retry Connection',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
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

  // Build Property Card from Database Data
  Widget _buildPropertyCard(Article property) {
    return Container(
      width: 280,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Image
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              color: Colors.grey[200],
            ),
            child: property.image != null && property.image!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    property.image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        child: Center(
                          child: Icon(Icons.home, size: 48, color: Colors.grey[400]),
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  child: Center(
                    child: Icon(Icons.home, size: 48, color: Colors.grey[400]),
                  ),
                ),
          ),
          
          // Property Info
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  property.title ?? 'Caribbean Property',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: SuriStayColors.deepTeal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                
                // Location
                if (property.address?.country != null)
                  Row(
                    children: [
                      Icon(Icons.location_on, 
                           size: 16, 
                           color: SuriStayColors.warningOrange),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${property.address!.city ?? ''}, ${property.address!.country}',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                
                SizedBox(height: 8),
                
                // Price and Details
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '\$${property.propertyInfo?.price ?? '0'} ${property.propertyInfo?.pricePostfix ?? 'USD'}',
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: SuriStayColors.warningOrange,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                
                // Bedrooms and Bathrooms
                Row(
                  children: [
                    if (property.features?.bedrooms != null)
                      Row(
                        children: [
                          Icon(Icons.bed, size: 16, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text(
                            '${property.features!.bedrooms}',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    if (property.features?.bedrooms != null && 
                        property.features?.bathrooms != null)
                      SizedBox(width: 16),
                    if (property.features?.bathrooms != null)
                      Row(
                        children: [
                          Icon(Icons.bathtub, size: 16, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text(
                            '${property.features!.bathrooms}',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _applyPropertyFilters(PropertyFilterCriteria filters) {
    // Apply property filters to the current property display
    setState(() {
      // Here you can filter the properties based on the criteria
      print('Applying filters:');
      print('Bedrooms: ${filters.bedrooms}');
      print('Bathrooms: ${filters.bathrooms}');
      print('Price Range: \$${filters.minPrice} - \$${filters.maxPrice}');
      print('Property Type: ${filters.propertyType}');
      print('City: ${filters.selectedCity}');
      print('Near Sea: ${filters.nearSea}');
      print('Has Pool: ${filters.hasPool}');
      print('Has Parking: ${filters.hasParking}');
      print('Furnished: ${filters.furnished}');
      
      // TODO: Implement actual filtering logic for mock properties
      // You can filter the regionDestinations data or any property list
      // based on the filter criteria
    });
  }
}
