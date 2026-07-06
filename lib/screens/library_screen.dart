import 'package:flutter/material.dart';
import 'package:my_app/pages/artist_page.dart';
import 'package:my_app/pages/favorite_page.dart';
import 'package:my_app/pages/playlist_page.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Playlists'),
              Tab(text: 'Artists'),
              Tab(text: 'Favorites'),
            ],
          ),
          Expanded(child: TabBarView(children: [PlaylistPage(), ArtistPage(),FavoritePage() ])),
        ],
      ),
    );
  }
}

