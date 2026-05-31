import 'package:flutter/material.dart';

/// SuriStay Caribbean Brand Colors
/// 
/// This class contains all the official SuriStay Caribbean brand colors
/// following the Caribbean-inspired design system with warm, tropical colors
/// that evoke the feeling of paradise and luxury real estate.
class SuriStayColors {
  // Primary Brand Colors
  /// Deep Caribbean Green - Primary brand color
  static const Color darkGreen = Color(0xFF006633);
  
  /// Vibrant Caribbean Red - Secondary accent color
  static const Color vibrantRed = Color(0xFFE4002B);
  
  /// Bright Caribbean Yellow - Tertiary accent color
  static const Color brightYellow = Color(0xFFFFCC00);
  
  // Secondary Colors
  /// Tropical Turquoise - For highlights and interactive elements
  static const Color turquoise = Color(0xFF2EC4B6);
  
  /// Warm Off-White - Background color for light mode
  static const Color offWhite = Color(0xFFF8F9FA);
  
  /// Deep Teal - For headings and important text
  static const Color deepTeal = Color(0xFF1B3A4B);
  
  /// Warm Gray - For borders and subtle elements
  static const Color warmGray = Color(0xFFE0E0E0);
  
  // Functional Colors
  /// WhatsApp Green - For WhatsApp integration
  static const Color whatsappGreen = Color(0xFF25D366);
  
  /// Success Green - For positive actions and confirmations
  static const Color successGreen = Color(0xFF52C41A);
  
  /// Warning Orange - For warnings and important notices
  static const Color warningOrange = Color(0xFFFA8C16);
  
  /// Info Blue - For informational elements (Caribbean turquoise)
  static const Color infoBlue = Color(0xFF2EC4B6);
  
  /// Purple Accent - For special features and premium elements
  static const Color purpleAccent = Color(0xFF722ED1);
  
  // Gradient Combinations
  /// Caribbean Sunset Gradient - From dark green to turquoise
  static const LinearGradient caribbeanSunset = LinearGradient(
    colors: [darkGreen, turquoise],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Tropical Paradise Gradient - From turquoise to bright yellow
  static const LinearGradient tropicalParadise = LinearGradient(
    colors: [turquoise, brightYellow],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  /// Vibrant Accent Gradient - From vibrant red to warning orange
  static const LinearGradient vibrantAccent = LinearGradient(
    colors: [vibrantRed, warningOrange],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Caribbean Green-Blue Gradient - From dark green to turquoise
  static const LinearGradient caribbeanGreenBlue = LinearGradient(
    colors: [darkGreen, turquoise],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Color Schemes for Different Property Types
  /// Beach Property Colors
  static const List<Color> beachPropertyColors = [
    turquoise,
    infoBlue,
    successGreen,
  ];
  
  /// Mountain Property Colors
  static const List<Color> mountainPropertyColors = [
    darkGreen,
    deepTeal,
    successGreen,
  ];
  
  /// City Property Colors
  static const List<Color> cityPropertyColors = [
    vibrantRed,
    purpleAccent,
    warningOrange,
  ];
  
  /// Luxury Property Colors
  static const List<Color> luxuryPropertyColors = [
    darkGreen,
    brightYellow,
    vibrantRed,
  ];
  
  // Utility Methods
  /// Get a color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  
  /// Get a lighter shade of a color
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
  
  /// Get a darker shade of a color
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
  
  /// Get random property color based on index
  static Color getPropertyColor(int index) {
    final colors = [
      darkGreen,
      vibrantRed,
      turquoise,
      successGreen,
      warningOrange,
      infoBlue,
      purpleAccent,
      brightYellow,
    ];
    return colors[index % colors.length];
  }
}
