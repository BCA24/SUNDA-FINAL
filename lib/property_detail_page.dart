// Create this file as property_detail_page.dart

import 'package:flutter/material.dart';

class PropertyDetailPage extends StatefulWidget {
  final Map<String, dynamic> property;
  
  const PropertyDetailPage({Key? key, required this.property}) : super(key: key);
  
  @override
  _PropertyDetailPageState createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  bool isFavorite = false;
  int currentImageIndex = 0;
  
  // SuriStay Design Colors
  static const Color primaryBlue = Color(0xFF1E40AF);
  static const Color oceanBlue = Color(0xFF0EA5E9);
  static const Color tropicalGreen = Color(0xFF10B981);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Property image header
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: primaryBlue,
            leading: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: primaryBlue, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Property image placeholder
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [oceanBlue, tropicalGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.villa, size: 48, color: Colors.white),
                          SizedBox(height: 12),
                          Text(
                            'Luxury Beachfront Villa',
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Image counter
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${currentImageIndex + 1} / 8',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              // Favorite button
              Container(
                margin: EdgeInsets.only(right: 16, top: 8),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey[600],
                    size: 20,
                  ),
                  onPressed: () => setState(() => isFavorite = !isFavorite),
                ),
              ),
            ],
          ),
          
          // Property details
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  Text(
                    '\$850,000',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: primaryBlue,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Property type
                  Text(
                    'Luxury Villa',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: tropicalGreen,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, color: textSecondary, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Seven Mile Beach, Grand Cayman',
                        style: TextStyle(
                          fontSize: 16,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  
                  // Features row
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFeature('🛏️', '4', 'Bedrooms'),
                        _buildFeature('🚿', '3', 'Bathrooms'),
                        _buildFeature('📐', '2,400', 'Sq Ft'),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  
                  // Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Stunning beachfront villa with panoramic ocean views. This modern luxury property features an open-plan design, private pool, and direct beach access. Perfect for those seeking the ultimate Caribbean lifestyle.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                  SizedBox(height: 32),
                  
                  // Amenities
                  Text(
                    'Amenities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _buildAmenity('Private Pool'),
                      _buildAmenity('Beach Access'),
                      _buildAmenity('Air Conditioning'),
                      _buildAmenity('Garage'),
                      _buildAmenity('Ocean View'),
                      _buildAmenity('Modern Kitchen'),
                    ],
                  ),
                  
                  SizedBox(height: 100), // Space for bottom buttons
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Bottom action buttons
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Call button
            Expanded(
              child: OutlinedButton(
                onPressed: () => _makePhoneCall(),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: primaryBlue, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Call',
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            
            // Contact Agent button
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => _contactAgent(),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Contact Agent',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: TextStyle(fontSize: 24)),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildAmenity(String amenity) {
    return Row(
      children: [
        Icon(Icons.check, color: tropicalGreen, size: 16),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            amenity,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
            ),
          ),
        ),
      ],
    );
  }

  void _makePhoneCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling agent...'),
        backgroundColor: tropicalGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _contactAgent() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening contact form...'),
        backgroundColor: tropicalGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }
}