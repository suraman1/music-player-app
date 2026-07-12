import 'package:flutter/material.dart';
import 'package:my_app/providers/music_provider.dart';
import 'package:my_app/providers/navigation_provider.dart';
import 'package:my_app/providers/theme_provider.dart';
import 'package:my_app/routes/router.dart';
import 'package:my_app/routes/routes.dart';
import 'package:my_app/services/music_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MusicService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider())
        ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Music player',
          theme: themeProvider.currentTheme,
          initialRoute: Routes.splash,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}
