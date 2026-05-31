import 'package:flutter/material.dart';
import 'package:houzi_package/widgets/caribbean_map_placeholder.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import '../../constants/suristay_colors.dart';

class CaribbeanMapPage extends StatefulWidget {
  final String? selectedCountry;
  final List<dynamic>? properties;

  const CaribbeanMapPage({
    Key? key,
    this.selectedCountry,
    this.properties,
  }) : super(key: key);

  @override
  State<CaribbeanMapPage> createState() => _CaribbeanMapPageState();
}

class _CaribbeanMapPageState extends State<CaribbeanMapPage> {
  String? selectedCountry;
  
  final List<Map<String, dynamic>> sampleProperties = [
    {
      'id': 1,
      'title': 'Beachfront Villa in Kingston',
      'country': 'Jamaica',
      'price': '\$245,000',
      'bedrooms': 3,
      'bathrooms': 2,
      'area': '2,100 sq ft',
      'image': 'https://example.com/villa1.jpg',
      'description': 'Stunning beachfront villa with panoramic ocean views',
      'featured': true,
    },
    {
      'id': 2,
      'title': 'Luxury Condo in Bridgetown',
      'country': 'Barbados',
      'price': '\$385,000',
      'bedrooms': 2,
      'bathrooms': 2,
      'area': '1,800 sq ft',
      'image': 'https://example.com/condo1.jpg',
      'description': 'Modern luxury condominium in the heart of the city',
      'featured': false,
    },
    {
      'id': 3,
      'title': 'Family Home in Port of Spain',
      'country': 'Trinidad',
      'price': '\$175,000',
      'bedrooms': 4,
      'bathrooms': 3,
      'area': '2,500 sq ft',
      'image': 'https://example.com/home1.jpg',
      'description': 'Spacious family home with large garden',
      'featured': true,
    },
    {
      'id': 4,
      'title': 'Resort Property in Nassau',
      'country': 'Bahamas',
      'price': '\$450,000',
      'bedrooms': 2,
      'bathrooms': 2,
      'area': '1,600 sq ft',
      'image': 'https://example.com/resort1.jpg',
      'description': 'Exclusive resort property with beach access',
      'featured': true,
    },
    {
      'id': 5,
      'title': 'Riverfront Property in Paramaribo',
      'country': 'Suriname',
      'price': '\$125,000',
      'bedrooms': 3,
      'bathrooms': 2,
      'area': '1,900 sq ft',
      'image': 'https://example.com/river1.jpg',
      'description': 'Peaceful riverfront property with modern amenities',
      'featured': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.selectedCountry;
  }

  List<Map<String, dynamic>> _getFilteredProperties() {
    if (selectedCountry == null) return sampleProperties;
    return sampleProperties.where((property) => property['country'] == selectedCountry).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProperties = _getFilteredProperties();
    
    return Scaffold(
      backgroundColor: SuriStayColors.darkGreen,
      appBar: AppBarWidget(
        appBarTitle: selectedCountry != null 
            ? 'Properties in $selectedCountry'
            : 'Caribbean Properties Map',
        backgroundColor: SuriStayColors.darkGreen,
      ),
      body: Column(
        children: [
          // Caribbean Map
          Container(
            height: 350,
            margin: EdgeInsets.all(16),
            child: CaribbeanMapPlaceholder(
              title: "Caribbean Real Estate Map",
              height: 350,
              onCountrySelected: (country) {
                setState(() {
                  selectedCountry = selectedCountry == country ? null : country;
                });
              },
            ),
          ),
          
          // Properties List
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedCountry != null 
                              ? 'Properties in $selectedCountry'
                              : 'All Caribbean Properties',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: SuriStayColors.darkGreen,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: SuriStayColors.warningOrange,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            '${filteredProperties.length} properties',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Properties Grid
                  Expanded(
                    child: filteredProperties.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.home_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No properties found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                if (selectedCountry != null) ...[
                                  SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedCountry = null;
                                      });
                                    },
                                    child: Text(
                                      'Show all properties',
                                      style: TextStyle(color: SuriStayColors.warningOrange),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: filteredProperties.length,
                            itemBuilder: (context, index) {
                              final property = filteredProperties[index];
                              return _buildPropertyCard(property);
                            },
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

  Widget _buildPropertyCard(Map<String, dynamic> property) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: property['featured'] ? SuriStayColors.warningOrange : Colors.grey[200]!,
          width: property['featured'] ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Image Placeholder
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  SuriStayColors.turquoise.withOpacity(0.7),
                  SuriStayColors.darkGreen.withOpacity(0.7),
                ],
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home,
                        size: 48,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Text(
                        property['country'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (property['featured'])
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: SuriStayColors.warningOrange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Featured',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Property Info
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property['title'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: SuriStayColors.darkGreen,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  property['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),
                
                // Property Details Row
                Row(
                  children: [
                    _buildPropertyDetail(Icons.bed, '${property['bedrooms']} bed'),
                    SizedBox(width: 16),
                    _buildPropertyDetail(Icons.bathtub, '${property['bathrooms']} bath'),
                    SizedBox(width: 16),
                    _buildPropertyDetail(Icons.square_foot, property['area']),
                  ],
                ),
                
                SizedBox(height: 12),
                
                // Price and Action Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      property['price'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: SuriStayColors.warningOrange,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle view details
                        _showPropertyDetails(property);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SuriStayColors.turquoise,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('View Details'),
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

  Widget _buildPropertyDetail(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showPropertyDetails(Map<String, dynamic> property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Property details content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property['title'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: SuriStayColors.darkGreen,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: SuriStayColors.warningOrange, size: 16),
                        SizedBox(width: 4),
                        Text(
                          property['country'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    Text(
                      property['description'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Property specs
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSpec('Bedrooms', property['bedrooms'].toString()),
                          _buildSpec('Bathrooms', property['bathrooms'].toString()),
                          _buildSpec('Area', property['area']),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    Text(
                      'Price: ${property['price']}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: SuriStayColors.warningOrange,
                      ),
                    ),
                    
                    Spacer(),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Contact request sent!'),
                                  backgroundColor: SuriStayColors.turquoise,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SuriStayColors.turquoise,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text('Contact Agent'),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added to favorites!'),
                                  backgroundColor: SuriStayColors.warningOrange,
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: SuriStayColors.warningOrange,
                              side: BorderSide(color: SuriStayColors.warningOrange),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text('Save Property'),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpec(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: SuriStayColors.darkGreen,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}