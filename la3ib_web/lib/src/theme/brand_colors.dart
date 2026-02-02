import 'package:flutter/material.dart';

/// LA3IB Brand Colors
/// Based on KSA heritage with modern, energetic execution
class BrandColors {
  BrandColors._(); // Private constructor to prevent instantiation

  // ==================== Primary Palette ====================
  
  /// KSA Green - Heritage, Energy, Growth
  static const Color primaryGreen = Color(0xFF00A651);
  static const Color secondaryGreen = Color(0xFF2ECC71);
  static const Color darkGreen = Color(0xFF006837);
  
  /// Energy Orange - Action, Urgency, CTAs
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color lightOrange = Color(0xFFFF8C61);
  static const Color darkOrange = Color(0xFFE84A19);
  
  /// Trust Blue - Reliability, Professional
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color lightBlue = Color(0xFF64B5F6);
  static const Color darkBlue = Color(0xFF1976D2);
  
  /// Warning Yellow
  static const Color warningYellow = Color(0xFFFFC107);
  static const Color lightYellow = Color(0xFFFFD54F);
  
  // ==================== Semantic Colors ====================
  
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFEF5350);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF29B6F6);
  
  // ==================== Light Mode Neutrals ====================
  
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceDim = Color(0xFFF1F3F5);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightTextDisabled = Color(0xFFBDBDBD);
  
  // ==================== Dark Mode Neutrals ====================
  
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceBright = Color(0xFF2C2C2C);
  static const Color darkBorder = Color(0xFF333333);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkTextDisabled = Color(0xFF666666);
  
  // ==================== Gradients ====================
  
  /// Primary brand gradient (green)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, secondaryGreen],
  );
  
  /// Energy gradient (orange to pink)
  static const LinearGradient energyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryOrange, Color(0xFFFF4081)],
  );
  
  /// Hero gradient (green to blue)
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, primaryBlue],
  );
  
  // ==================== Sport-Specific Colors ====================
  
  static const Map<String, Color> sportColors = {
    'Football': Color(0xFF00A651), // Green
    'Basketball': Color(0xFFFF6B35), // Orange
    'Padel': Color(0xFF2196F3),     // Blue
    'Volleyball': Color(0xFFFFD54F), // Yellow
    'Tennis': Color(0xFF4CAF50),    // Light green
  };
  
  // ==================== Status Colors ====================
  
  /// Game status colors
  static const Color statusOpen = Color(0xFF4CAF50);
  static const Color statusFull = Color(0xFFFF9800);
  static const Color statusCancelled = Color(0xFFEF5350);
  static const Color statusCompleted = Color(0xFF9E9E9E);
  
  // ==================== Helper Methods ====================
  
  /// Get color for a specific sport
  static Color getSportColor(String sport) {
    return sportColors[sport] ?? primaryGreen;
  }
  
  /// Get status color
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return statusOpen;
      case 'full':
        return statusFull;
      case 'cancelled':
        return statusCancelled;
      case 'completed':
        return statusCompleted;
      default:
        return lightTextSecondary;
    }
  }
  
  /// Get contrasting text color for a background
  static Color getContrastingTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? lightTextPrimary : darkTextPrimary;
  }
}

// Note: BrandColors is a utility class with static members.
// Access colors directly via BrandColors.propertyName
