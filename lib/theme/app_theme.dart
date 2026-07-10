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

    textTheme: AppTextStyles.textTheme.apply(
      bodyColor: Colors.black87,
      displayColor: Colors.black87,
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

    sliderTheme: SliderThemeData(
      activeTrackColor: Colors.blue,
      inactiveTrackColor: Colors.grey[200],
      trackHeight: 4,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
      
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

    tabBarTheme: TabBarThemeData(
      dividerColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.tab
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

    textTheme: AppTextStyles.textTheme.apply(
      bodyColor: Colors.black87,
      displayColor: Colors.black87
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

    sliderTheme: SliderThemeData(
      activeTrackColor: Colors.blue,
      inactiveTrackColor: Colors.grey[200],
      trackHeight: 4,
      thumbShape: RoundSliderThumbShape(
        enabledThumbRadius: 8,
      ),
      overlayShape: RoundSliderOverlayShape(
        overlayRadius: 16
      )
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

    
    tabBarTheme: TabBarThemeData(
      dividerColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.tab,
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