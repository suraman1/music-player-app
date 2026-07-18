import 'package:flutter/material.dart';
import 'package:my_app/providers/search_provider.dart';
import 'package:my_app/services/music_service.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:my_app/routes/routes.dart';

class ArtistPlay extends StatelessWidget {
  final ArtistModel artist;
  const ArtistPlay({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    final songs = context
        .read<SearchProvider>()
        .filterdArtistSongs(context, artist)
        .toList();
    final musicService = context.read<MusicService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(artist.artist),
      ),
      body: songs.isEmpty
          ? const Center(
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
            )
          : ListView.builder(
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
                    song.title.isEmpty ||
                            RegExp(r'^[?!]+$').hasMatch(song.title)
                        ? "Unknown"
                        : song.title.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(song.artist ?? "Unknown Artist"),
                  trailing: Selector<MusicService,
                      ({bool isPlaying, int? songId})>(
                    selector: (_, service) => (
                      isPlaying: service.isPlaying,
                      songId: service.currentSong?.id,
                    ),
                    builder: (_, state, __) {
                      final isCurrentPlaying =
                          state.isPlaying && state.songId == song.id;
                      return IconButton(
                        onPressed: () async {
                          if (musicService.currentSong == song) {
                            await musicService.playPause(song);
                          } else {
                            await musicService.playSong(song);
                          }
                        },
                        icon: Icon(
                          isCurrentPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                      );
                    },
                  ),
                  onTap: () async {
                    Navigator.pushNamed(context, Routes.play);
                    if (musicService.currentSong == song &&
                        !musicService.isPlaying) {
                      await musicService.playPause(song);
                    } else if (musicService.currentSong != song) {
                      await musicService.playSong(song);
                    }
                  },
                );
              },
            ),
    );
  }
}