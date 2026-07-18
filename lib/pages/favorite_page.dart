import 'package:flutter/material.dart';
import 'package:my_app/routes/routes.dart';
import 'package:my_app/services/music_service.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final musicService = context.watch<MusicService>();
    final favSongs = musicService.favoriteSongIds;
    final songs = musicService.songs;

    if (favSongs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_off, size: 64, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              'No favSongs are added to favorites',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const Text(
              'Add favSongs to favorite on menu',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: favSongs.length,
      itemBuilder: (context, index) {
        final song = songs.firstWhere((s) => s.id == index);
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
            selector: (_, song) =>
                (isPlaying: song.isPlaying, songId: song.currentSong?.id),
            builder: (_, state, _) {
              final currentState = state.isPlaying && state.songId == song.id;
              return IconButton(
                onPressed: () async {
                  if (musicService.currentSong == song) {
                    await musicService.playPause(song);
                  } else {
                    await musicService.playSong(song);
                  }
                },
                icon: Icon(currentState ? Icons.pause : Icons.play_arrow),
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
