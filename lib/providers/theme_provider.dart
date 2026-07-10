import 'package:flutter/material.dart';
import 'package:my_app/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = AppTheme.darkTheme;
  ThemeData get currentTheme => _currentTheme;

  bool get isDarkMode => _currentTheme == AppTheme.darkTheme;

  void toggleTheme() {
    _currentTheme = isDarkMode ? AppTheme.lightTheme : AppTheme.darkTheme;
    notifyListeners();
  }
}
