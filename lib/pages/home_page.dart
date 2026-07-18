import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/providers/navigation_provider.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/library_screen.dart';
import 'package:my_app/screens/search_screen.dart';
import 'package:my_app/services/music_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:my_app/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final MusicService service;
  List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
    LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<NavigationProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music player'),
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
      body: screens[navigationProvider.currentIndex],
      drawer: MyDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationProvider.currentIndex,
        onTap: (index) {
          navigationProvider.changeIndex(index);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_add),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
