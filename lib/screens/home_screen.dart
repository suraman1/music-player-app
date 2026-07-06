import 'package:flutter/material.dart';
import 'package:my_app/pages/album_page.dart';
import 'package:my_app/pages/all_song_page.dart';
import 'package:my_app/pages/artist_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'All Songs'),
              Tab(text: 'Albums'),
              Tab(text: 'Artists'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                AllSongPage(),
                AlbumPage(),
                ArtistPage()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
