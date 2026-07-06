import 'package:flutter/material.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/library_screen.dart';
import 'package:my_app/screens/profile_screen.dart';
import 'package:my_app/screens/search_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:my_app/theme/app_styles.dart';
import 'package:my_app/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
    LibraryScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music player'),
        titleTextStyle: AppTextStyles.bodyLarge,
        actions: [
          IconButton(
            onPressed: () async {
              Uri uri = Uri.parse("https://google.com");
              Share.share(uri.toString());
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: screens[_currentIndex],
      drawer: MyDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_add),
            label: 'Library',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
