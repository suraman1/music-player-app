import 'package:flutter/material.dart';
import 'package:my_app/routes/routes.dart';
import 'package:my_app/services/music_service.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:provider/provider.dart';

class AllSongPage extends StatelessWidget {
  AllSongPage({super.key});

  @override
  Widget build(BuildContext context) {
    final musicService = context.read<MusicService>();
    final songs = musicService.songs;

    if (songs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_off, size: 64, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              'No songs found',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const Text(
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
          title: Text(
            song.title.isEmpty || RegExp(r'^[?!]+$').hasMatch(song.title)
                ? "Unknown"
                : song.title.trim(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(song.artist ?? "Unknown Artist"),
          trailing: Selector<MusicService, ({bool isPlaying, int? songId})>(
            selector: (_, song) => (
              isPlaying: song.isPlaying,
              songId: song.currentSong?.id
            ),
            builder: (_, state , _) {
              final currentState = state.isPlaying && state.songId == song.id;
              return IconButton(
                onPressed: () async {
                  if (musicService.currentSong == song) {
                    await musicService.playPause(song);
                  } else {
                    await musicService.playSong(song);
                  }
                },
                icon: Icon(
                      currentState
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
              );
            },
          ),
          onTap: () async {
            Navigator.pushNamed(context, Routes.play);
            if (musicService.currentSong == song && !musicService.isPlaying) {
              await musicService.playPause(song);
            }
            if (musicService.currentSong != song) {
              await musicService.playSong(song);
            }
          },
        );
      },
    );
  }
}
