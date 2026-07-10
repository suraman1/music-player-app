import 'package:flutter/material.dart';
import 'package:my_app/pages/search_page.dart';
import 'package:my_app/pages/setting_page.dart';
import 'package:my_app/routes/routes.dart';
import 'package:my_app/pages/home_page.dart';
import 'package:my_app/screens/splash_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case Routes.search:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case Routes.setting:
        // final String userId = settings.arguments;
        return MaterialPageRoute(builder: (_) => const SettingPage());
      case Routes.splash:
        // final String userId = settings.arguments;
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      default:
        return MaterialPageRoute(builder: (_) => const SettingPage());
      // return MaterialPageRoute(builder : (_) = > const NotFoundPage());
    }
  }
}
