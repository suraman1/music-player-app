import 'package:flutter/material.dart';
import 'package:my_app/routes/router.dart';
import 'package:my_app/routes/routes.dart';
import 'package:my_app/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      debugShowCheckedModeBanner: false,
      title: 'Music player',
      theme: AppTheme.darkTheme,
      initialRoute: Routes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}