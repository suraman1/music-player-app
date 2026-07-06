import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/theme/app_colors.dart';
import 'package:my_app/theme/app_styles.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.darkBackground,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surfacePrimary,
      error: AppColors.error,
    ),

    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(
        color: AppColors.textPrimary,
      ),
      displayMedium: AppTextStyles.displayMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      displaySmall: AppTextStyles.displaySmall.copyWith(
        color: AppColors.textPrimary,
      ),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(
        color: AppColors.textPrimary,
      ),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(
        color: AppColors.textPrimary,
      ),
      titleLarge: AppTextStyles.titleLarge.copyWith(
        color: AppColors.textPrimary,
      ),
      titleMedium: AppTextStyles.titleMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      titleSmall: AppTextStyles.titleSmall.copyWith(
        color: AppColors.textPrimary,
      ),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.textPrimary,
      ),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary,
      ),
      bodySmall: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textSecondary,
      ),
      labelLarge: AppTextStyles.labelLarge.copyWith(
        color: AppColors.textSecondary,
      ),
      labelMedium: AppTextStyles.labelMedium.copyWith(
        color: AppColors.textSecondary,
      ),
      labelSmall: AppTextStyles.labelSmall.copyWith(
        color: AppColors.textSecondary,
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      iconTheme: IconThemeData(
        color: AppColors.icon,
        size: 28,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.darkBackground,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    ),

    iconTheme: const IconThemeData(
      color: AppColors.icon,
      size: 24,
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
    ),

    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.icon,
      textColor: AppColors.textPrimary,
      selectedColor: AppColors.primary,
      selectedTileColor: AppColors.surfaceSecondary,
    ),

    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.surfacePrimary,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfacePrimary,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.icon,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColors.lightBackground,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: Colors.white,
      error: AppColors.error,
    ),

textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(
        color: Colors.black87,
      ),
      displayMedium: AppTextStyles.displayMedium.copyWith(
        color: Colors.black87,
      ),
      displaySmall: AppTextStyles.displaySmall.copyWith(
        color: Colors.black87,
      ),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(
        color: Colors.black87,
      ),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(
        color: Colors.black87,
      ),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(
        color: Colors.black87,
      ),
      titleLarge: AppTextStyles.titleLarge.copyWith(
        color: Colors.black87,
      ),
      titleMedium: AppTextStyles.titleMedium.copyWith(
        color: Colors.black87,
      ),
      titleSmall: AppTextStyles.titleSmall.copyWith(
        color: Colors.black87,
      ),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(
        color: Colors.black87,
      ),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(
        color: Colors.black54,
      ),
      bodySmall: AppTextStyles.bodySmall.copyWith(
        color: Colors.black54,
      ),
      labelLarge: AppTextStyles.labelLarge.copyWith(
        color: Colors.black54,
      ),
      labelMedium: AppTextStyles.labelMedium.copyWith(
        color: Colors.black54,
      ),
      labelSmall: AppTextStyles.labelSmall.copyWith(
        color: Colors.black54,
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      iconTheme: IconThemeData(
        color: Colors.black87,
        size: 28,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.lightBackground,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ),

    iconTheme: const IconThemeData(
      color: Colors.black87,
      size: 24,
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.lightDivider,
      thickness: 1,
    ),

    listTileTheme: const ListTileThemeData(
      iconColor: Colors.black87,
      textColor: Colors.black87,
      selectedColor: AppColors.primary,
      selectedTileColor: Color(0xFFEDE7FF),
    ),

    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.black54,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}