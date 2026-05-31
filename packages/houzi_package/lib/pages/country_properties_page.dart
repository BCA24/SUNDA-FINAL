import 'package:flutter/material.dart';
import '../../constants/suristay_colors.dart';
import '../../models/article.dart';
import 'property_details_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CountryPropertiesPage extends StatefulWidget {
  final String countryName;
  
  const CountryPropertiesPage({
    Key? key,
    required this.countryName,
  }) : super(key: key);

  @override
  State<CountryPropertiesPage> createState() => _CountryPropertiesPageState();
}

class _CountryPropertiesPageState extends State<CountryPropertiesPage> {
  List<Article> properties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch properties from local API server
      // Use emulator-compatible host for Android emulator or change to your device IP
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/properties/country/${Uri.encodeComponent(widget.countryName)}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('🏠 Received ${data.length} properties from API');
        final List<Article> fetchedProperties = data.map((prop) {
          print('📋 Property: ${prop['title']} - Beds: ${prop['bedrooms']}, Baths: ${prop['bathrooms']}, Price: ${prop['sale_price']}');
          
          Article article = Article(
            id: prop['id'] != null ? int.tryParse(prop['id'].toString()) ?? 0 : 0,
            title: prop['title'] ?? 'Untitled Property',
            content: prop['description'] ?? 'No description provided',
            image: prop['primary_image'],
            date: prop['published_at'] ?? prop['created_at'],
          );
          
          // Set PropertyInfo
          article.propertyInfo = PropertyInfo(
            price: prop['sale_price']?.toString() ?? '0',
            firstPrice: prop['sale_price']?.toString() ?? '0',
          );
          
          // Set Features
          article.features = Features(
            bedrooms: prop['bedrooms']?.toString() ?? '0',
            bathrooms: prop['bathrooms']?.toString() ?? '0',
            buildingArea: prop['area_sqm']?.toString() ?? '0',
          );
          
          // Clean up city name - remove generic default names
          String cleanCityName = prop['city_name'] ?? '';
          if (cleanCityName.toLowerCase().contains('default') || 
              cleanCityName.toLowerCase().contains('unknown') || 
              cleanCityName.trim().isEmpty) {
            cleanCityName = '';
          }
          
          // Set Address - THIS WAS MISSING!
          article.address = Address(
            address: prop['address'] ?? '',
            country: prop['country_name'] ?? '',
            city: cleanCityName,
            state: prop['state_name'] ?? '',
          );
          
          // Set propertyDetailsMap for price display
          final salePrice = prop['sale_price']?.toString() ?? '0';
          article.propertyDetailsMap = {
            'PRICE': salePrice,
            'FIRST_PRICE': salePrice,
            'property_address': prop['address'] ?? '',
            'property_country': prop['country_name'] ?? '',
            'property_city': cleanCityName,
            'property_price': salePrice,
          };
          print('[DEBUG] Property mapped: title=${article.title}, sale_price=$salePrice');
          
          return article;
        }).toList();
        
        if (mounted) {
          setState(() {
            properties = fetchedProperties;
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load properties: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading properties: $e');
      if (mounted) {
        setState(() {
          properties = [];
          isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load properties. Make sure the server is running.'),
            backgroundColor: SuriStayColors.warningOrange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SuriStayColors.darkGreen,
      appBar: AppBar(
        backgroundColor: SuriStayColors.darkGreen,
        title: Text(
          '${widget.countryName} Properties',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              // Could navigate to map view here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Map view coming soon!'),
                  backgroundColor: SuriStayColors.warningOrange,
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              SuriStayColors.darkGreen,
              SuriStayColors.darkGreen.withOpacity(0.8),
            ],
          ),
        ),
        child: Column(
          children: [
            // Header with country info
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    SuriStayColors.warningOrange.withOpacity(0.9),
                    SuriStayColors.turquoise.withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        widget.countryName.substring(0, 2).toUpperCase(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: SuriStayColors.darkGreen,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.countryName,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${properties.length} Properties Available',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Properties list
            Expanded(
              child: isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              SuriStayColors.warningOrange,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Loading ${widget.countryName} properties...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : properties.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.home_outlined,
                                size: 64,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No properties found in ${widget.countryName}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: properties.length,
                          itemBuilder: (context, index) {
                            final article = properties[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Property Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                    child: Container(
                                      height: 200,
                                      width: double.infinity,
                                      child: Image.network(
                                        article.title?.contains('Villa') == true 
                                            ? 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&h=600&fit=crop'
                                            : article.title?.contains('Apartment') == true
                                                ? 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800&h=600&fit=crop'
                                                : 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=800&h=600&fit=crop',
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: SuriStayColors.turquoise.withOpacity(0.3),
                                            child: Center(
                                              child: Icon(
                                                Icons.home,
                                                size: 40,
                                                color: SuriStayColors.darkGreen,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  
                                  // Property Details
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Title and Price
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                article.title ?? 'Property',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: SuriStayColors.darkGreen,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: SuriStayColors.warningOrange,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                '\$${article.propertyInfo?.price ?? '285K'}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        
                                        SizedBox(height: 8),
                                        
                                        // Location
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 16,
                                              color: SuriStayColors.turquoise,
                                            ),
                                            SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                '${widget.countryName}',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        
                                        SizedBox(height: 12),
                                        
                                        // Property specs
                                        Row(
                                          children: [
                                            _buildPropertySpec(
                                              Icons.bed,
                                              article.features?.bedrooms ?? '3',
                                              'Beds',
                                            ),
                                            SizedBox(width: 16),
                                            _buildPropertySpec(
                                              Icons.bathtub,
                                              article.features?.bathrooms ?? '2',
                                              'Baths',
                                            ),
                                            SizedBox(width: 16),
                                            _buildPropertySpec(
                                              Icons.square_foot,
                                              article.features?.buildingArea ?? '1500',
                                              'sq ft',
                                            ),
                                          ],
                                        ),
                                        
                                        SizedBox(height: 12),
                                        
                                        // Description
                                        Text(
                                          article.content ?? 'Beautiful property in ${widget.countryName}',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 14,
                                            height: 1.3,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        
                                        SizedBox(height: 16),
                                        
                                        // View Details Button
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => PropertyDetailsScreen(
                                                    property: article,
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: SuriStayColors.turquoise,
                                              foregroundColor: Colors.white,
                                              padding: EdgeInsets.symmetric(vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              'View Details',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertySpec(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: SuriStayColors.turquoise,
        ),
        SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: SuriStayColors.darkGreen,
          ),
        ),
        SizedBox(width: 2),
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
