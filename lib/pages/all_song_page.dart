import 'package:flutter/material.dart';
import 'package:my_app/services/music_service.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:provider/provider.dart';

class AllSongPage extends StatelessWidget {
  const AllSongPage({super.key});

  @override
  Widget build(BuildContext context) {
    final musicservice = context.watch<MusicService>();
    final songs = musicservice.songs;

    if (songs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_off, size: 64, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'No songs found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'Add music files to your device',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return ListTile(
          leading: QueryArtworkWidget(
            id: song.id, 
            type: ArtworkType.AUDIO,
            nullArtworkWidget: const Icon(Icons.music_note),
          ),
          title: Text(song.title),
          subtitle: Text(song.artist ?? "Unknown Artist"),
          trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.play_arrow)),

        );
      },

    );
  }
}
