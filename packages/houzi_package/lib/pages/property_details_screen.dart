import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/suristay_colors.dart';
import '../../models/article.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final Article property;

  const PropertyDetailsScreen({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  int currentImageIndex = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SuriStayColors.darkGreen,
      body: CustomScrollView(
        slivers: [
          // App Bar with images
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: SuriStayColors.darkGreen,
            iconTheme: IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Image carousel
                  PageView.builder(
                    controller: pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentImageIndex = index;
                      });
                    },
                    itemCount: _getImageUrls().length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(_getImageUrls()[index]),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {
                              // Fallback to default image
                            },
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // Image indicators
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _getImageUrls().asMap().entries.map((entry) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentImageIndex == entry.key
                                ? SuriStayColors.warningOrange
                                : Colors.white.withOpacity(0.5),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  // Price badge
                  Positioned(
                    top: 60,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: SuriStayColors.warningOrange,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        '\$${_formatPrice(widget.property.propertyInfo?.price ?? widget.property.propertyDetailsMap?['property_price'] ?? '0')}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and basic info
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.property.title ?? 'Beautiful Property',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: SuriStayColors.darkGreen,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: SuriStayColors.turquoise,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _getFullAddress(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        
                        // Property specs
                        Row(
                          children: [
                            _buildSpec(
                              Icons.bed,
                              '${widget.property.features?.bedrooms ?? '3'} Bed',
                            ),
                            SizedBox(width: 20),
                            _buildSpec(
                              Icons.bathroom,
                              '${widget.property.features?.bathrooms ?? '2'} Bath',
                            ),
                            SizedBox(width: 20),
                            _buildSpec(
                              Icons.square_foot,
                              '${widget.property.features?.propertyArea ?? '1500'} ft²',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Property details section
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: SuriStayColors.turquoise.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: SuriStayColors.turquoise.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Property Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: SuriStayColors.darkGreen,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildDetailRow('Property Type', _getPropertyType()),
                        _buildDetailRow('Year Built', widget.property.propertyDetailsMap?['property_year_built'] ?? '2020'),
                        _buildDetailRow('Garage', '${widget.property.features?.garage ?? '2'} Cars'),
                        _buildDetailRow('Lot Size', '${widget.property.features?.landArea ?? '0.5'} Acres'),
                        _buildDetailRow('Status', _getPropertyStatus()),
                        _buildDetailRow('Property ID', widget.property.id?.toString() ?? '001'),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Description
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: SuriStayColors.darkGreen,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          widget.property.content ?? _getDefaultDescription(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Features section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Features & Amenities',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: SuriStayColors.darkGreen,
                          ),
                        ),
                        SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: _getFeatures().map((feature) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: SuriStayColors.warningOrange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: SuriStayColors.warningOrange.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                feature,
                                style: TextStyle(
                                  color: SuriStayColors.darkGreen,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 40),
                  
                  // Contact buttons
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _makePhoneCall,
                            icon: Icon(Icons.phone, size: 20),
                            label: Text(
                              'Call',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _sendEmail,
                            icon: Icon(Icons.email, size: 20),
                            label: Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpec(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: SuriStayColors.turquoise,
          size: 18,
        ),
        SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: SuriStayColors.darkGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getImageUrls() {
    // Mock images for demonstration
    return [
      'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&h=600&fit=crop',
      'https://images.unsplash.com/photo-1582063289852-62e3ba2747f8?w=800&h=600&fit=crop',
      'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&h=600&fit=crop',
      'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800&h=600&fit=crop'
    ];
  }

  String _formatPrice(String price) {
    try {
      int priceInt = int.parse(price);
      if (priceInt >= 1000000) {
        return '${(priceInt / 1000000).toStringAsFixed(1)}M';
      } else if (priceInt >= 1000) {
        return '${(priceInt / 1000).toStringAsFixed(0)}K';
      }
      return priceInt.toString();
    } catch (e) {
      return price;
    }
  }

  String _getFullAddress() {
    // Try to get address from the Address object first (this is where our real data is)
    String address = widget.property.address?.address ?? '';
    String city = widget.property.address?.city ?? '';
    String country = widget.property.address?.country ?? '';
    
    // Fallback to propertyDetailsMap if Address object is empty
    if (address.isEmpty && city.isEmpty && country.isEmpty) {
      Map<String, dynamic>? details = widget.property.propertyDetailsMap;
      address = details?['property_address'] ?? '';
      city = details?['property_city'] ?? '';
      country = details?['property_country'] ?? '';
    }
    
    print('🏠 Detail screen address debug: address="$address", city="$city", country="$country"');
    
    // Clean up the city name - remove "Default City" and other generic names
    String cleanCity = city;
    if (city.toLowerCase().contains('default') || 
        city.toLowerCase().contains('unknown') || 
        city.isEmpty) {
      cleanCity = '';
    }
    
    // Build clean address format
    if (address.isNotEmpty && cleanCity.isNotEmpty) {
      return '$address, $cleanCity, $country';
    } else if (address.isNotEmpty) {
      return '$address, $country';
    } else if (cleanCity.isNotEmpty) {
      return '$cleanCity, $country';
    } else {
      return country.isNotEmpty ? country : 'Caribbean Location';
    }
  }

  String _getPropertyType() {
    return widget.property.propertyDetailsMap?['property_type'] ?? 'Villa';
  }

  String _getPropertyStatus() {
    String status = widget.property.propertyDetailsMap?['property_status'] ?? 'for-sale';
    return status.replaceAll('-', ' ').split(' ').map((word) => 
        word.substring(0, 1).toUpperCase() + word.substring(1)
    ).join(' ');
  }

  String _getDefaultDescription() {
    return 'This stunning Caribbean property offers an exceptional lifestyle with modern amenities and breathtaking views. Perfect for both vacation home and permanent residence, featuring spacious living areas, high-end finishes, and prime location access to beautiful beaches and local attractions.';
  }

  List<String> _getFeatures() {
    return [
      'Ocean View',
      'Swimming Pool',
      'Air Conditioning',
      'Modern Kitchen',
      'Spacious Terrace',
      'Security System',
      'Garden',
      'Beach Access',
      'Parking',
      'WiFi Ready'
    ];
  }

  void _makePhoneCall() async {
    String phoneNumber = widget.property.propertyDetailsMap?['property_agent_contact'] ?? '+1-876-555-0123';
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        _showContactInfo('Phone', phoneNumber);
      }
    } catch (e) {
      _showContactInfo('Phone', phoneNumber);
    }
  }

  void _sendEmail() async {
    String email = 'info@caribbeandreamrealty.com';
    String subject = 'Inquiry about ${widget.property.title}';
    String body = 'Hi, I am interested in this property and would like more information.';
    
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );
    
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        _showContactInfo('Email', email);
      }
    } catch (e) {
      _showContactInfo('Email', email);
    }
  }

  void _showContactInfo(String type, String contact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$type Contact'),
          content: SelectableText(contact),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}