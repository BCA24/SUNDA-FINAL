import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:houzi_package/pages/map_view.dart';
import '../constants/suristay_colors.dart';
import '../pages/caribbean_map_page.dart';

class CaricomExplorerCarousel extends StatefulWidget {
  final Function(String)? onCountrySelected;
  final Function(String)? onRegionExplored;

  const CaricomExplorerCarousel({
    Key? key,
    this.onCountrySelected,
    this.onRegionExplored,
  }) : super(key: key);

  @override
  _CaricomExplorerCarouselState createState() => _CaricomExplorerCarouselState();
}

class _CaricomExplorerCarouselState extends State<CaricomExplorerCarousel>
    with TickerProviderStateMixin {
  PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  // Caribbean regions data
  final List<Map<String, dynamic>> _regions = [
    {
      'id': 'west',
      'name': '🌊 West Caribbean',
      'propertyCount': '2 Properties',
      'gradient': [SuriStayColors.turquoise, SuriStayColors.successGreen],
      'countries': [
        {
          'name': 'Jamaica',
          'flag': '🇯🇲',
          'properties': '1 property',
          'coordinates': [18.4762, -77.8937]
        },
        {
          'name': 'Bahamas',
          'flag': '🇧🇸',
          'properties': '1 property',
          'coordinates': [25.0343, -77.3963]
        },
      ],
    },
    {
      'id': 'east',
      'name': '🏝️ East Caribbean',
      'propertyCount': '3 Properties',
      'gradient': [SuriStayColors.darkGreen, SuriStayColors.successGreen],
      'countries': [
        {
          'name': 'Barbados',
          'flag': '🇧🇧',
          'properties': '1 property',
          'coordinates': [13.1939, -59.5432]
        },
        {
          'name': 'St. Lucia',
          'flag': '🇱🇨',
          'properties': '1 property',
          'coordinates': [14.0101, -60.9875]
        },
        {
          'name': 'Grenada',
          'flag': '🇬🇩',
          'properties': '1 property',
          'coordinates': [12.0562, -61.7482]
        },
      ],
    },
    {
      'id': 'mainland',
      'name': '🌴 Mainland Caribbean',
      'propertyCount': '1 Property',
      'gradient': [SuriStayColors.successGreen, SuriStayColors.darkGreen],
      'countries': [
        {
          'name': 'Trinidad & Tobago',
          'flag': '🇹🇹',
          'properties': '1 property',
          'coordinates': [10.6596, -61.5089]
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // Auto-advance carousel
    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        _nextPage();
        _startAutoAdvance();
      }
    });
  }

  void _nextPage() {
    final nextPage = (_currentPage + 1) % _regions.length;
    _pageController.animateToPage(
      nextPage,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.explore,
                  color: SuriStayColors.darkGreen,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Explore Caribbean Regions',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: SuriStayColors.darkGreen,
                  ),
                ),
              ],
            ),
          ),

          // Carousel
          Container(
            height: 280,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                if (mounted) {
                  setState(() {
                    _currentPage = index;
                  });
                }
              },
              itemCount: _regions.length,
              itemBuilder: (context, index) {
                return _buildRegionCard(_regions[index]);
              },
            ),
          ),

          // Dots Indicator
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _regions.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      entry.key,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: _currentPage == entry.key ? 12 : 8,
                    height: _currentPage == entry.key ? 12 : 8,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == entry.key
                          ? SuriStayColors.successGreen
                          : Colors.grey[300],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionCard(Map<String, dynamic> region) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: region['gradient'],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: SuriStayColors.darkGreen.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: CustomPaint(
                painter: CaribbeanPatternPainter(),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Region Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          region['name'],
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          region['propertyCount'],
                          style: GoogleFonts.openSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Countries Grid
                  Expanded(
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: region['countries'].length > 2 ? 2 : 1,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: region['countries'].length,
                      itemBuilder: (context, index) {
                        final country = region['countries'][index];
                        return _buildCountryCard(country);
                      },
                    ),
                  ),

                  SizedBox(height: 15),

                  // Explore Button
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _exploreRegion(region);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.explore,
                            color: SuriStayColors.darkGreen,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Explore ${region['name'].split(' ')[1]} Region',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: SuriStayColors.darkGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryCard(Map<String, dynamic> country) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _exploreCountry(country);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              country['flag'],
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    country['name'],
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    country['properties'],
                    style: GoogleFonts.openSans(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exploreCountry(Map<String, dynamic> country) {
    if (widget.onCountrySelected != null) {
      widget.onCountrySelected!(country['name']);
    }

    // Navigate to Caribbean map view with country selection
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CaribbeanMapPage(
          selectedCountry: country['name'],
        ),
      ),
    );
  }

  void _exploreRegion(Map<String, dynamic> region) {
    if (widget.onRegionExplored != null) {
      widget.onRegionExplored!(region['id']);
    }

    // Navigate to Caribbean map view centered on region
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CaribbeanMapPage(),
      ),
    );
  }
}

class CaribbeanPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw wave patterns
    final path = Path();
    for (int i = 0; i < 3; i++) {
      final y = size.height * 0.2 + (i * size.height * 0.3);
      path.moveTo(0, y);
      
      for (double x = 0; x <= size.width; x += 40) {
        path.quadraticBezierTo(
          x + 20, y - 10,
          x + 40, y,
        );
      }
    }

    canvas.drawPath(path, paint);

    // Draw palm tree silhouettes
    paint.color = Colors.white.withOpacity(0.05);
    paint.style = PaintingStyle.fill;

    // Simple palm tree shapes
    final palmRect1 = Rect.fromCircle(
      center: Offset(size.width * 0.8, size.height * 0.8),
      radius: 15,
    );
    canvas.drawOval(palmRect1, paint);

    final palmRect2 = Rect.fromCircle(
      center: Offset(size.width * 0.15, size.height * 0.7),
      radius: 10,
    );
    canvas.drawOval(palmRect2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}