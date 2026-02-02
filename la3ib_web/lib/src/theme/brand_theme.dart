import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'brand_colors.dart';
import 'brand_typography.dart';

/// LA3IB Brand Theme
/// Complete Material 3 theme implementation
class BrandTheme {
  BrandTheme._();

  // ==================== Border Radius ====================
  
  static const BorderRadius radiusNone = BorderRadius.zero;
  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(4));
  static const BorderRadius radiusMedium = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radiusXLarge = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusXXLarge = BorderRadius.all(Radius.circular(24));
  static const BorderRadius radiusRound = BorderRadius.all(Radius.circular(9999));
  
  // ==================== Shadows ====================
  
  static const List<BoxShadow> shadowNone = [];
  
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];
  
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
  ];
  
  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 15,
      offset: Offset(0, 10),
    ),
  ];
  
  static const List<BoxShadow> shadowXl = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 25,
      offset: Offset(0, 20),
    ),
  ];
  
  // Dark mode shadows (stronger)
  static const List<BoxShadow> shadowSmDark = [
    BoxShadow(
      color: Color(0x4D000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];
  
  static const List<BoxShadow> shadowMdDark = [
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
  ];
  
  // ==================== Light Theme ====================
  
  static ThemeData lightTheme() {
    final ColorScheme colorScheme = ColorScheme.light(
      primary: BrandColors.primaryGreen,
      onPrimary: Colors.white,
      primaryContainer: BrandColors.secondaryGreen.withValues(alpha: 0.2),
      onPrimaryContainer: BrandColors.darkGreen,
      
      secondary: BrandColors.primaryOrange,
      onSecondary: Colors.white,
      secondaryContainer: BrandColors.lightOrange.withValues(alpha: 0.2),
      onSecondaryContainer: BrandColors.darkOrange,
      
      tertiary: BrandColors.primaryBlue,
      onTertiary: Colors.white,
      tertiaryContainer: BrandColors.lightBlue.withValues(alpha: 0.2),
      onTertiaryContainer: BrandColors.darkBlue,
      
      error: BrandColors.error,
      onError: Colors.white,
      errorContainer: BrandColors.error.withValues(alpha: 0.1),
      onErrorContainer: BrandColors.error,
      
      surface: BrandColors.lightSurface,
      onSurface: BrandColors.lightTextPrimary,
      surfaceContainerHighest: BrandColors.lightSurfaceDim,
      onSurfaceVariant: BrandColors.lightTextSecondary,
      
      outline: BrandColors.lightBorder,
      outlineVariant: BrandColors.lightBorder.withValues(alpha: 0.5),
      
      shadow: Colors.black.withValues(alpha: 0.1),
      scrim: Colors.black.withValues(alpha: 0.4),
      
      inverseSurface: BrandColors.darkSurface,
      onInverseSurface: BrandColors.darkTextPrimary,
      inversePrimary: BrandColors.secondaryGreen,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      
      // Typography
      textTheme: BrandTypography.getTextTheme(brightness: Brightness.light),
      
      // Scaffold
      scaffoldBackgroundColor: BrandColors.lightBackground,
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: BrandColors.lightSurface,
        foregroundColor: BrandColors.lightTextPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: BrandTypography.h2(color: BrandColors.lightTextPrimary),
        iconTheme: const IconThemeData(color: BrandColors.lightTextPrimary),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      
      // Card
      cardTheme: CardThemeData(
        color: BrandColors.lightSurface,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: radiusXLarge,
          side: BorderSide(color: BrandColors.lightBorder, width: 1),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      // Buttons
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: BrandColors.primaryOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: const RoundedRectangleBorder(borderRadius: radiusLarge),
          textStyle: BrandTypography.buttonLarge(color: Colors.white),
          elevation: 0,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: BrandColors.primaryGreen,
          side: const BorderSide(color: BrandColors.primaryGreen, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: const RoundedRectangleBorder(borderRadius: radiusLarge),
          textStyle: BrandTypography.buttonLarge(color: BrandColors.primaryGreen),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BrandColors.primaryGreen,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: BrandTypography.buttonMedium(color: BrandColors.primaryGreen),
        ),
      ),
      
      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        fillColor: BrandColors.lightSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: radiusLarge,
          borderSide: const BorderSide(color: BrandColors.lightBorder, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radiusLarge,
          borderSide: const BorderSide(color: BrandColors.lightBorder, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radiusLarge,
          borderSide: const BorderSide(color: BrandColors.primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radiusLarge,
          borderSide: const BorderSide(color: BrandColors.error, width: 2),
        ),
        labelStyle: BrandTypography.labelLarge(color: BrandColors.lightTextSecondary),
        hintStyle: BrandTypography.bodyMedium(color: BrandColors.lightTextDisabled),
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: BrandColors.lightSurfaceDim,
        selectedColor: BrandColors.primaryGreen,
        labelStyle: BrandTypography.labelMedium(color: BrandColors.lightTextPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: const RoundedRectangleBorder(borderRadius: radiusRound),
        side: BorderSide.none,
      ),
      
      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: BrandColors.lightSurface,
        shape: const RoundedRectangleBorder(borderRadius: radiusXXLarge),
        titleTextStyle: BrandTypography.h2(color: BrandColors.lightTextPrimary),
        contentTextStyle: BrandTypography.bodyLarge(color: BrandColors.lightTextSecondary),
      ),
      
      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: BrandColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      
      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: BrandColors.darkSurface,
        contentTextStyle: BrandTypography.bodyMedium(color: Colors.white),
        shape: const RoundedRectangleBorder(borderRadius: radiusLarge),
        behavior: SnackBarBehavior.floating,
      ),
      
      // Divider
      dividerTheme: const DividerThemeData(
        color: BrandColors.lightBorder,
        thickness: 1,
        space: 16,
      ),
      
      // Icon
      iconTheme: const IconThemeData(
        color: BrandColors.lightTextPrimary,
        size: 24,
      ),
    );
  }

  // ==================== Dark Theme ====================
  
  static ThemeData darkTheme() {
    final ColorScheme colorScheme = ColorScheme.dark(
      primary: BrandColors.secondaryGreen,
      onPrimary: BrandColors.darkBackground,
      primaryContainer: BrandColors.darkGreen,
      onPrimaryContainer: BrandColors.secondaryGreen,
      
      secondary: BrandColors.primaryOrange,
      onSecondary: BrandColors.darkBackground,
      secondaryContainer: BrandColors.darkOrange,
      onSecondaryContainer: BrandColors.lightOrange,
      
      tertiary: BrandColors.lightBlue,
      onTertiary: BrandColors.darkBackground,
      tertiaryContainer: BrandColors.darkBlue,
      onTertiaryContainer: BrandColors.lightBlue,
      
      error: BrandColors.error,
      onError: BrandColors.darkBackground,
      errorContainer: BrandColors.error.withValues(alpha: 0.2),
      onErrorContainer: BrandColors.error,
      
      surface: BrandColors.darkSurface,
      onSurface: BrandColors.darkTextPrimary,
      surfaceContainerHighest: BrandColors.darkSurfaceBright,
      onSurfaceVariant: BrandColors.darkTextSecondary,
      
      outline: BrandColors.darkBorder,
      outlineVariant: BrandColors.darkBorder.withValues(alpha: 0.5),
      
      shadow: Colors.black.withValues(alpha: 0.3),
      scrim: Colors.black.withValues(alpha: 0.6),
      
      inverseSurface: BrandColors.lightSurface,
      onInverseSurface: BrandColors.lightTextPrimary,
      inversePrimary: BrandColors.primaryGreen,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      
      // Typography
      textTheme: BrandTypography.getTextTheme(brightness: Brightness.dark),
      
      // Scaffold
      scaffoldBackgroundColor: BrandColors.darkBackground,
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: BrandColors.darkSurface,
        foregroundColor: BrandColors.darkTextPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: BrandTypography.h2(color: BrandColors.darkTextPrimary),
        iconTheme: const IconThemeData(color: BrandColors.darkTextPrimary),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      
      // Card
      cardTheme: CardThemeData(
        color: BrandColors.darkSurface,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: radiusXLarge,
          side: BorderSide(color: BrandColors.darkBorder, width: 1),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      // Buttons
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: BrandColors.primaryOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: const RoundedRectangleBorder(borderRadius: radiusLarge),
          textStyle: BrandTypography.buttonLarge(color: Colors.white),
          elevation: 0,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: BrandColors.secondaryGreen,
          side: const BorderSide(color: BrandColors.secondaryGreen, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: const RoundedRectangleBorder(borderRadius: radiusLarge),
          textStyle: BrandTypography.buttonLarge(color: BrandColors.secondaryGreen),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BrandColors.secondaryGreen,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: BrandTypography.buttonMedium(color: BrandColors.secondaryGreen),
        ),
      ),
      
      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        fillColor: BrandColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: radiusLarge,
          borderSide: const BorderSide(color: BrandColors.darkBorder, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radiusLarge,
          borderSide: const BorderSide(color: BrandColors.darkBorder, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radiusLarge,
          borderSide: const BorderSide(color: BrandColors.secondaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radiusLarge,
          borderSide: const BorderSide(color: BrandColors.error, width: 2),
        ),
        labelStyle: BrandTypography.labelLarge(color: BrandColors.darkTextSecondary),
        hintStyle: BrandTypography.bodyMedium(color: BrandColors.darkTextDisabled),
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: BrandColors.darkSurfaceBright,
        selectedColor: BrandColors.secondaryGreen,
        labelStyle: BrandTypography.labelMedium(color: BrandColors.darkTextPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: const RoundedRectangleBorder(borderRadius: radiusRound),
        side: BorderSide.none,
      ),
      
      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: BrandColors.darkSurface,
        shape: const RoundedRectangleBorder(borderRadius: radiusXXLarge),
        titleTextStyle: BrandTypography.h2(color: BrandColors.darkTextPrimary),
        contentTextStyle: BrandTypography.bodyLarge(color: BrandColors.darkTextSecondary),
      ),
      
      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: BrandColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      
      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: BrandColors.darkSurfaceBright,
        contentTextStyle: BrandTypography.bodyMedium(color: Colors.white),
        shape: const RoundedRectangleBorder(borderRadius: radiusLarge),
        behavior: SnackBarBehavior.floating,
      ),
      
      // Divider
      dividerTheme: const DividerThemeData(
        color: BrandColors.darkBorder,
        thickness: 1,
        space: 16,
      ),
      
      // Icon
      iconTheme: const IconThemeData(
        color: BrandColors.darkTextPrimary,
        size: 24,
      ),
    );
  }
}
