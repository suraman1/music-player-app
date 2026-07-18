import 'package:flutter/material.dart';
import 'package:my_app/providers/search_provider.dart';
import 'package:my_app/routes/routes.dart';
import 'package:my_app/services/music_service.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    final musicService = context.read<MusicService>();
    final controller = searchProvider.controller;
    final filteredSongs = searchProvider.filteredSongs(context).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SearchBar(
              keyboardType: TextInputType.name,
              leading: const Icon(Icons.search),
              controller: controller,
              onChanged: (val) => searchProvider.onChanged(context, val),
              onSubmitted: (val) => searchProvider.onSubmitted(context, val),
            ),
            Expanded(
              child: filteredSongs.isEmpty
                  ? const Center(child: Text('No songs found'))
                  : ListView.builder(
                      itemCount: filteredSongs.length,
                      itemBuilder: (context, index) {
                        final song = filteredSongs[index];
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
                                  isCurrentPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
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
            ),
          ],
        ),
      ),
    );
  }
}