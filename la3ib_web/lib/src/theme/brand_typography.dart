import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// LA3IB Typography System
/// Using Poppins for Latin, Tajawal for Arabic
class BrandTypography {
  BrandTypography._();

  // ==================== Font Families ====================
  
  static const String primaryFontFamily = 'Poppins';
  static const String arabicFontFamily = 'Cairo'; // Using Cairo as it's available in google_fonts
  
  // ==================== Text Styles ====================
  
  /// Display Large - 32px / Bold - Page titles, hero text
  static TextStyle displayLarge({Color? color}) => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: color,
    letterSpacing: -0.5,
  );
  
  /// Display Medium - 28px / Bold - Section headers
  static TextStyle displayMedium({Color? color}) => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: color,
    letterSpacing: -0.5,
  );
  
  /// Heading 1 - 24px / Bold - Major sections
  static TextStyle h1({Color? color}) => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: color,
    letterSpacing: -0.3,
  );
  
  /// Heading 2 - 20px / SemiBold - Card titles, subsections
  static TextStyle h2({Color? color}) => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: color,
    letterSpacing: -0.2,
  );
  
  /// Heading 3 - 18px / SemiBold - Smaller headings
  static TextStyle h3({Color? color}) => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: color,
  );
  
  /// Heading 4 - 16px / Medium - List headers
  static TextStyle h4({Color? color}) => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: color,
  );
  
  /// Body Large - 16px / Regular - Main content
  static TextStyle bodyLarge({Color? color}) => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: color,
  );
  
  /// Body Medium - 14px / Regular - Secondary content
  static TextStyle bodyMedium({Color? color}) => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: color,
  );
  
  /// Body Small - 12px / Regular - Captions, labels
  static TextStyle bodySmall({Color? color}) => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: color,
  );
  
  /// Button Large - 16px / SemiBold - Primary CTAs
  static TextStyle buttonLarge({Color? color}) => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: color,
    letterSpacing: 0.5,
  );
  
  /// Button Medium - 14px / SemiBold - Secondary buttons
  static TextStyle buttonMedium({Color? color}) => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: color,
    letterSpacing: 0.5,
  );
  
  /// Label Large - 14px / Medium - Form labels
  static TextStyle labelLarge({Color? color}) => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: color,
  );
  
  /// Label Medium - 12px / Medium - Small labels, badges
  static TextStyle labelMedium({Color? color}) => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: color,
    letterSpacing: 0.5,
  );
  
  /// Label Small - 10px / Medium - Tiny labels
  static TextStyle labelSmall({Color? color}) => GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: color,
    letterSpacing: 0.5,
  );
  
  // ==================== Arabic Text Styles ====================
  
  /// Arabic Display - 32px / Bold
  static TextStyle displayLargeArabic({Color? color}) => GoogleFonts.cairo(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: color,
  );
  
  /// Arabic Heading - 24px / Bold
  static TextStyle h1Arabic({Color? color}) => GoogleFonts.cairo(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: color,
  );
  
  /// Arabic Body - 16px / Regular
  static TextStyle bodyLargeArabic({Color? color}) => GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: color,
  );
  
  // ==================== Special Styles ====================
  
  /// Number style - for prices, counts
  static TextStyle number({Color? color, double? fontSize}) => GoogleFonts.poppins(
    fontSize: fontSize ?? 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: color,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
  
  /// Monospace - for codes, IDs
  static TextStyle monospace({Color? color, double? fontSize}) => GoogleFonts.jetBrainsMono(
    fontSize: fontSize ?? 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: color,
  );
  
  // ==================== Material 3 TextTheme ====================
  
  /// Get Material 3 compliant TextTheme
  static TextTheme getTextTheme({required Brightness brightness}) {
    final Color textColor = brightness == Brightness.light 
        ? const Color(0xFF212121) 
        : const Color(0xFFFFFFFF);
    
    return TextTheme(
      displayLarge: displayLarge(color: textColor),
      displayMedium: displayMedium(color: textColor),
      displaySmall: h1(color: textColor),
      
      headlineLarge: h1(color: textColor),
      headlineMedium: h2(color: textColor),
      headlineSmall: h3(color: textColor),
      
      titleLarge: h2(color: textColor),
      titleMedium: h3(color: textColor),
      titleSmall: h4(color: textColor),
      
      bodyLarge: bodyLarge(color: textColor),
      bodyMedium: bodyMedium(color: textColor),
      bodySmall: bodySmall(color: textColor),
      
      labelLarge: labelLarge(color: textColor),
      labelMedium: labelMedium(color: textColor),
      labelSmall: labelSmall(color: textColor),
    );
  }
}

// Note: BrandTypography is a utility class with static members.
// Access typography styles directly via BrandTypography.methodName()
