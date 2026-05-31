import 'package:flutter/material.dart';
import '../../constants/suristay_colors.dart';

class CaribbeanMapWidget extends StatefulWidget {
  final String? selectedCountry;
  final Function(String)? onCountryTap;

  const CaribbeanMapWidget({
    Key? key,
    this.selectedCountry,
    this.onCountryTap,
  }) : super(key: key);

  @override
  State<CaribbeanMapWidget> createState() => _CaribbeanMapWidgetState();
}

class _CaribbeanMapWidgetState extends State<CaribbeanMapWidget> {
  String? hoveredCountry;

  final Map<String, CountryMapData> countries = {
    'Jamaica': CountryMapData('JM', Offset(0.25, 0.65), '4.2K properties'),
    'Bahamas': CountryMapData('BS', Offset(0.35, 0.25), '3.8K properties'),
    'Haiti': CountryMapData('HT', Offset(0.45, 0.55), '1.2K properties'),
    'Trinidad': CountryMapData('TT', Offset(0.65, 0.85), '2.7K properties'),
    'Barbados': CountryMapData('BB', Offset(0.75, 0.75), '3.1K properties'),
    'Antigua': CountryMapData('AG', Offset(0.70, 0.60), '1.4K properties'),
    'Dominica': CountryMapData('DM', Offset(0.68, 0.65), '675 properties'),
    'Grenada': CountryMapData('GD', Offset(0.62, 0.80), '892 properties'),
    'St. Lucia': CountryMapData('LC', Offset(0.66, 0.70), '1.2K properties'),
    'St. Vincent': CountryMapData('VC', Offset(0.64, 0.75), '543 properties'),
    'Belize': CountryMapData('BZ', Offset(0.15, 0.45), '890 properties'),
    'Guyana': CountryMapData('GY', Offset(0.55, 0.90), '2.3K properties'),
    'Suriname': CountryMapData('SR', Offset(0.60, 0.88), '1.8K properties'),
    'Montserrat': CountryMapData('MS', Offset(0.69, 0.58), '156 properties'),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            SuriStayColors.turquoise.withOpacity(0.1),
            SuriStayColors.warningOrange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: SuriStayColors.turquoise.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // Ocean background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    SuriStayColors.turquoise.withOpacity(0.2),
                    SuriStayColors.turquoise.withOpacity(0.4),
                  ],
                ),
              ),
            ),
            // Caribbean islands illustration
            CustomPaint(
              size: Size.infinite,
              painter: CaribbeanMapPainter(),
            ),
            // Country markers
            ...countries.entries.map((entry) => _buildCountryMarker(
              entry.key,
              entry.value,
            )),
            // Map title
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🏝️', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      'Caribbean Region',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: SuriStayColors.darkGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Legend
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tap to explore',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: SuriStayColors.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                SuriStayColors.warningOrange,
                                SuriStayColors.vibrantRed,
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Countries',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryMarker(String countryName, CountryMapData data) {
    final isSelected = widget.selectedCountry == countryName;
    final isHovered = hoveredCountry == countryName;
    final isHighlighted = isSelected || isHovered;

    return Positioned(
      left: data.position.dx * 300 - 20,
      top: data.position.dy * 350 - 20,
      child: GestureDetector(
        onTap: () => widget.onCountryTap?.call(countryName),
        child: MouseRegion(
          onEnter: (_) => setState(() => hoveredCountry = countryName),
          onExit: (_) => setState(() => hoveredCountry = null),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()..scale(isHighlighted ? 1.2 : 1.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Country marker
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isHighlighted
                        ? SuriStayColors.warningOrange
                        : SuriStayColors.turquoise,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isHighlighted 
                            ? SuriStayColors.warningOrange 
                            : SuriStayColors.turquoise).withOpacity(0.4),
                        blurRadius: isHighlighted ? 12 : 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      data.code,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Country info tooltip
                if (isHighlighted) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          countryName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: SuriStayColors.darkGreen,
                          ),
                        ),
                        Text(
                          data.propertyCount,
                          style: TextStyle(
                            fontSize: 10,
                            color: SuriStayColors.turquoise,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CountryMapData {
  final String code;
  final Offset position;
  final String propertyCount;

  CountryMapData(this.code, this.position, this.propertyCount);
}

class CaribbeanMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = SuriStayColors.darkGreen.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw simplified Caribbean islands
    final islands = [
      // Cuba (large island at top)
      Rect.fromLTWH(size.width * 0.2, size.height * 0.15, size.width * 0.3, size.height * 0.08),
      // Jamaica
      Rect.fromLTWH(size.width * 0.22, size.height * 0.6, size.width * 0.08, size.height * 0.04),
      // Hispaniola (Haiti/DR)
      Rect.fromLTWH(size.width * 0.4, size.height * 0.5, size.width * 0.12, size.height * 0.06),
      // Puerto Rico
      Rect.fromLTWH(size.width * 0.55, size.height * 0.48, size.width * 0.06, size.height * 0.03),
      // Lesser Antilles chain
      Rect.fromLTWH(size.width * 0.65, size.height * 0.55, size.width * 0.03, size.height * 0.25),
      // Trinidad
      Rect.fromLTWH(size.width * 0.62, size.height * 0.82, size.width * 0.04, size.height * 0.03),
      // Bahamas chain
      Rect.fromLTWH(size.width * 0.32, size.height * 0.2, size.width * 0.08, size.height * 0.15),
    ];

    for (final island in islands) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(island, const Radius.circular(8)),
        paint,
      );
    }

    // Draw some decorative wave patterns
    final wavePaint = Paint()
      ..color = SuriStayColors.turquoise.withOpacity(0.2)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 5; i++) {
      final path = Path();
      final y = size.height * 0.1 + (i * size.height * 0.15);
      path.moveTo(0, y);
      
      for (double x = 0; x < size.width; x += 20) {
        path.quadraticBezierTo(
          x + 10, y - 5,
          x + 20, y,
        );
      }
      
      canvas.drawPath(path, wavePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
