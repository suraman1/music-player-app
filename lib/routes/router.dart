import 'package:flutter/material.dart';
import 'package:my_app/pages/about_page.dart';
import 'package:my_app/pages/album_page.dart';
import 'package:my_app/pages/album_play.dart';
import 'package:my_app/pages/play_page.dart';
import 'package:my_app/pages/search_page.dart';
import 'package:my_app/pages/setting_page.dart';
import 'package:my_app/routes/routes.dart';
import 'package:my_app/pages/home_page.dart';
import 'package:my_app/screens/splash_screen.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case Routes.search:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case Routes.settings:
        // final String userId = settings.arguments;
        return MaterialPageRoute(builder: (_) => const SettingPage());
      case Routes.about:
        return MaterialPageRoute(builder: (_) => const AboutPage());
      case Routes.splash:
        // final String userId = settings.arguments;
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.album:
        return MaterialPageRoute(builder: (_) => const AlbumPage());
      case Routes.albumPlay:
        final AlbumModel selectedAlbum = settings.arguments as AlbumModel;
        return MaterialPageRoute(builder: (_) => AlbumPlay(album: selectedAlbum,));
      case Routes.play:
        return MaterialPageRoute(builder: (_) => const PlayPage());

      default:
        return MaterialPageRoute(builder: (_) => const SettingPage());
      // return MaterialPageRoute(builder : (_) = > const NotFoundPage());
    }
  }
}
