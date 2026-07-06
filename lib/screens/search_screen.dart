import 'package:flutter/material.dart';
import 'package:my_app/pages/all_song_page.dart';
import 'package:my_app/pages/folder_page.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [

          TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'All songs'),
              Tab(text: 'Folder')
            ],
          ),
          Expanded(child: TabBarView(children: [AllSongPage(), FolderPage()])),
        ],
      ),
    );
  }
}
