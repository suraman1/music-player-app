import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/routes/routes.dart';
import 'package:my_app/services/music_service.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:provider/provider.dart';

class AlbumPlay extends StatefulWidget {
  final AlbumModel album;

  const AlbumPlay({super.key, required this.album});

  @override
  State<AlbumPlay> createState() => _AlbumPlayState();
}

class _AlbumPlayState extends State<AlbumPlay> {
  List<SongModel> songs = [];

  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_loaded) {
      _loaded = true;
      _loadSongs();
    }
  }

  Future<void> _loadSongs() async {
    try {
      final musicService = context.read<MusicService>();

      final loadedSongs = musicService.getAllSongsFromAlbum(widget.album);
      debugPrint('Album: ${widget.album.album}');
      debugPrint('Songs found: ${loadedSongs.length}');

      for (final song in loadedSongs) {
        debugPrint(song.title);
      }
      if (!mounted) return;

      setState(() {
        songs = loadedSongs;
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Album songs error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final album = widget.album;

    return Scaffold(
      appBar: AppBar(
        title: Text(album.album, style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                QueryArtworkWidget(
                  id: album.id,
                  type: ArtworkType.ALBUM,
                  artworkHeight: 120,
                  artworkWidth: 120,
                  artworkQuality: FilterQuality.high,
                  nullArtworkWidget: const SizedBox(
                    width: 120,
                    height: 120,
                    child: const Icon(Icons.album, size: 64),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        album.album,
                        style: Theme.of(context).textTheme.titleLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        album.artist ?? 'Unknown Artist',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${album.numOfSongs} songs',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Selector<MusicService, bool>(
                        selector: (_, song) => song.isMute,
                        builder: (_, isMute, _) {
                          final musicService = context.read<MusicService>();
                          return ElevatedButton.icon(
                            onPressed: songs.isEmpty
                                ? null
                                : () => musicService.playAll(songs),
                            icon: musicService.isPlaying
                                ? const Icon(Icons.pause)
                                : const Icon(Icons.play_arrow),
                            label: const Text('Play All'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: songs.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.music_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'No songs found',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          const Text(
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

                        return Selector<MusicService, SongModel?>(
                          selector: (_, musicService) =>
                              musicService.currentSong,
                          builder: (_, currentSong, _) {
                            final musicService = context.read<MusicService>();
                            return ListTile(
                              onTap: () async {
                                Navigator.pushNamed(context, Routes.play);
                                if (musicService.currentSong == song &&
                                    !musicService.isPlaying) {
                                  await musicService.playPause(song);
                                }
                                if (musicService.currentSong != song) {
                                  await musicService.playSong(song);
                                }
                              },
                              leading: QueryArtworkWidget(
                                id: song.id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Icon(Icons.music_note),
                                ),
                              ),
                              title: Text(
                                song.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                song.artist ?? 'Unknown Artist',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: IconButton(
                                onPressed: () async {
                                  if (musicService.currentSong == song) {
                                    await musicService.playPause(song);
                                  } else {
                                    await musicService.playSong(song);
                                  }
                                },
                                icon: Icon(
                                  musicService.isPlaying &&
                                          musicService.currentSong?.id ==
                                              song.id
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                              ),
                            );
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
