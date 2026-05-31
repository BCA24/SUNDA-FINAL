import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constants/suristay_colors.dart';

/// Custom painters for Caribbean-style property illustrations
/// These painters create tropical, warm illustrations that evoke the Caribbean lifestyle

/// Paints a tropical house with palm trees for property cards
class CaribbeanPropertyPainter extends CustomPainter {
  final Color accentColor;
  final String propertyType;

  CaribbeanPropertyPainter(this.accentColor, {this.propertyType = 'house'});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint housePaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;
    
    final Paint roofPaint = Paint()
      ..color = SuriStayColors.darken(accentColor, 0.2)
      ..style = PaintingStyle.fill;
    
    final Paint palmPaint = Paint()
      ..color = SuriStayColors.darkGreen
      ..style = PaintingStyle.fill;
    
    final Paint sunPaint = Paint()
      ..color = SuriStayColors.brightYellow
      ..style = PaintingStyle.fill;

    // Draw sun in the background
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      size.width * 0.08,
      sunPaint,
    );

    switch (propertyType.toLowerCase()) {
      case 'villa':
      case 'luxury':
        _paintLuxuryVilla(canvas, size, housePaint, roofPaint);
        break;
      case 'beach':
      case 'beachfront':
        _paintBeachHouse(canvas, size, housePaint, roofPaint);
        break;
      case 'apartment':
      case 'condo':
        _paintApartmentBuilding(canvas, size, housePaint, roofPaint);
        break;
      default:
        _paintTropicalHouse(canvas, size, housePaint, roofPaint);
    }

    // Add palm tree
    _paintPalmTree(canvas, size, palmPaint);
  }

  void _paintTropicalHouse(Canvas canvas, Size size, Paint housePaint, Paint roofPaint) {
    // Main house structure
    final houseRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.25, 
        size.height * 0.45, 
        size.width * 0.4, 
        size.height * 0.3
      ),
      Radius.circular(4),
    );
    canvas.drawRRect(houseRect, housePaint);

    // Triangular roof
    final roofPath = Path();
    roofPath.moveTo(size.width * 0.2, size.height * 0.45);
    roofPath.lineTo(size.width * 0.45, size.height * 0.3);
    roofPath.lineTo(size.width * 0.7, size.height * 0.45);
    roofPath.close();
    canvas.drawPath(roofPath, roofPaint);

    // Door
    final doorPaint = Paint()..color = SuriStayColors.deepTeal;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.4, 
          size.height * 0.55, 
          size.width * 0.1, 
          size.height * 0.2
        ),
        Radius.circular(2),
      ),
      doorPaint,
    );

    // Window
    final windowPaint = Paint()..color = SuriStayColors.turquoise;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.3, 
          size.height * 0.5, 
          size.width * 0.08, 
          size.width * 0.08
        ),
        Radius.circular(2),
      ),
      windowPaint,
    );
  }

  void _paintLuxuryVilla(Canvas canvas, Size size, Paint housePaint, Paint roofPaint) {
    // Main villa structure (larger)
    final villaRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.2, 
        size.height * 0.4, 
        size.width * 0.5, 
        size.height * 0.35
      ),
      Radius.circular(6),
    );
    canvas.drawRRect(villaRect, housePaint);

    // Flat modern roof
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.18, 
          size.height * 0.35, 
          size.width * 0.54, 
          size.height * 0.08
        ),
        Radius.circular(4),
      ),
      roofPaint,
    );

    // Multiple windows
    final windowPaint = Paint()..color = SuriStayColors.turquoise;
    for (int i = 0; i < 3; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width * (0.25 + i * 0.12), 
            size.height * 0.5, 
            size.width * 0.08, 
            size.width * 0.08
          ),
          Radius.circular(2),
        ),
        windowPaint,
      );
    }
  }

  void _paintBeachHouse(Canvas canvas, Size size, Paint housePaint, Paint roofPaint) {
    // Beach house on stilts
    final stiltPaint = Paint()..color = SuriStayColors.deepTeal;
    
    // Draw stilts
    for (int i = 0; i < 4; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          size.width * (0.28 + i * 0.12), 
          size.height * 0.6, 
          size.width * 0.02, 
          size.height * 0.15
        ),
        stiltPaint,
      );
    }

    // Main house elevated
    final houseRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.25, 
        size.height * 0.35, 
        size.width * 0.4, 
        size.height * 0.25
      ),
      Radius.circular(4),
    );
    canvas.drawRRect(houseRect, housePaint);

    // Slanted roof for tropical style
    final roofPath = Path();
    roofPath.moveTo(size.width * 0.22, size.height * 0.35);
    roofPath.lineTo(size.width * 0.45, size.height * 0.25);
    roofPath.lineTo(size.width * 0.68, size.height * 0.35);
    roofPath.close();
    canvas.drawPath(roofPath, roofPaint);
  }

  void _paintApartmentBuilding(Canvas canvas, Size size, Paint housePaint, Paint roofPaint) {
    // Multi-story building
    final buildingRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.3, 
        size.height * 0.25, 
        size.width * 0.35, 
        size.height * 0.5
      ),
      Radius.circular(4),
    );
    canvas.drawRRect(buildingRect, housePaint);

    // Flat roof
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.28, 
          size.height * 0.2, 
          size.width * 0.39, 
          size.height * 0.08
        ),
        Radius.circular(4),
      ),
      roofPaint,
    );

    // Multiple floors of windows
    final windowPaint = Paint()..color = SuriStayColors.turquoise;
    for (int floor = 0; floor < 3; floor++) {
      for (int window = 0; window < 2; window++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              size.width * (0.35 + window * 0.15), 
              size.height * (0.35 + floor * 0.12), 
              size.width * 0.08, 
              size.width * 0.06
            ),
            Radius.circular(2),
          ),
          windowPaint,
        );
      }
    }
  }

  void _paintPalmTree(Canvas canvas, Size size, Paint palmPaint) {
    // Palm tree trunk
    final trunkPath = Path();
    trunkPath.moveTo(size.width * 0.15, size.height * 0.75);
    trunkPath.quadraticBezierTo(
      size.width * 0.12, size.height * 0.5,
      size.width * 0.18, size.height * 0.3,
    );
    
    final trunkPaint = Paint()
      ..color = SuriStayColors.darken(SuriStayColors.darkGreen, 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.015;
    
    canvas.drawPath(trunkPath, trunkPaint);

    // Palm fronds
    final frondPaint = Paint()..color = SuriStayColors.darkGreen;
    final frondPaths = [
      _createFrondPath(size, 0.18, 0.3, -0.3, -0.15),
      _createFrondPath(size, 0.18, 0.3, 0.3, -0.15),
      _createFrondPath(size, 0.18, 0.3, -0.1, -0.25),
      _createFrondPath(size, 0.18, 0.3, 0.1, -0.25),
    ];

    for (final frondPath in frondPaths) {
      canvas.drawPath(frondPath, frondPaint);
    }
  }

  Path _createFrondPath(Size size, double startX, double startY, double deltaX, double deltaY) {
    final path = Path();
    path.moveTo(size.width * startX, size.height * startY);
    path.quadraticBezierTo(
      size.width * (startX + deltaX * 0.5),
      size.height * (startY + deltaY * 0.5),
      size.width * (startX + deltaX),
      size.height * (startY + deltaY),
    );
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paints tropical waves for beach properties
class CaribbeanWavesPainter extends CustomPainter {
  final Color waveColor;
  final double animationValue;

  CaribbeanWavesPainter(this.waveColor, {this.animationValue = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Create wave pattern
    path.moveTo(0, size.height * 0.7);
    
    for (double x = 0; x <= size.width; x += size.width / 8) {
      final y = size.height * 0.7 + 
                (size.height * 0.1) * 
                (0.5 + 0.5 * math.sin(x / size.width + animationValue));
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Second wave layer
    final paint2 = Paint()
      ..color = waveColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height * 0.8);
    
    for (double x = 0; x <= size.width; x += size.width / 6) {
      final y = size.height * 0.8 + 
                (size.height * 0.08) * 
                (0.5 + 0.5 * math.sin(x / size.width * 1.5 + animationValue * 0.7));
      path2.lineTo(x, y);
    }
    
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Paints tropical mountains for mountain properties
class CaribbeanMountainsPainter extends CustomPainter {
  final Color mountainColor;

  CaribbeanMountainsPainter(this.mountainColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = mountainColor.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Create mountain silhouette
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.6);
    path.lineTo(size.width * 0.2, size.height * 0.3);
    path.lineTo(size.width * 0.4, size.height * 0.5);
    path.lineTo(size.width * 0.6, size.height * 0.2);
    path.lineTo(size.width * 0.8, size.height * 0.4);
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Add second mountain layer
    final paint2 = Paint()
      ..color = mountainColor.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height);
    path2.lineTo(0, size.height * 0.7);
    path2.lineTo(size.width * 0.3, size.height * 0.4);
    path2.lineTo(size.width * 0.5, size.height * 0.6);
    path2.lineTo(size.width * 0.7, size.height * 0.3);
    path2.lineTo(size.width, size.height * 0.6);
    path2.lineTo(size.width, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Extension methods for easy access to painters
extension CaribbeanPainters on Widget {
  /// Wraps the widget with a Caribbean property illustration
  Widget withCaribbeanProperty({
    required Color accentColor,
    String propertyType = 'house',
    double height = 80,
  }) {
    return Container(
      height: height,
      child: CustomPaint(
        painter: CaribbeanPropertyPainter(accentColor, propertyType: propertyType),
        child: this,
      ),
    );
  }

  /// Wraps the widget with Caribbean waves
  Widget withCaribbeanWaves({
    Color waveColor = SuriStayColors.turquoise,
    double animationValue = 0.0,
    double height = 60,
  }) {
    return Container(
      height: height,
      child: CustomPaint(
        painter: CaribbeanWavesPainter(waveColor, animationValue: animationValue),
        child: this,
      ),
    );
  }

  /// Wraps the widget with Caribbean mountains
  Widget withCaribbeanMountains({
    Color mountainColor = SuriStayColors.darkGreen,
    double height = 80,
  }) {
    return Container(
      height: height,
      child: CustomPaint(
        painter: CaribbeanMountainsPainter(mountainColor),
        child: this,
      ),
    );
  }
}
