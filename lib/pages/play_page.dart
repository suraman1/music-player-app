import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_app/services/music_service.dart';
import 'package:my_app/theme/app_styles.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _isDragging = false;
  double _dragValue = 0.0;
  late MusicService music;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    music = context.read<MusicService>();
    music.playingStream.listen((val) {
      setState(() {
        isPlaying = val;
      });
    });
    music.durationStream.listen((val) {
      setState(() {
        duration = val ?? Duration.zero;
      });
    });
    music.positionStream.listen((val) {
      setState(() {
        position = val;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MusicService>(
        builder: (_, musicService, _) {
          final SongModel? song = musicService.currentSong;

          if (musicService.currentSong == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.music_off, size: 64, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No song is playing',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (isPlaying && !_controller.isAnimating) {
            _controller.repeat();
          } else if (!isPlaying && _controller.isAnimating) {
            _controller.stop();
          }

          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_downward),
                      ),
                      const Text('Now playing'),
                      IconButton(
                        onPressed: () => {},
                        icon: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (_, child) {
                        return Transform.rotate(
                          angle: _controller.value * 2 * pi,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 20,
                                  blurRadius: 30,
                                ),
                              ],
                            ),
                            child: QueryArtworkWidget(
                              id: song?.id ?? 0,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Colors.blue, Colors.purple],
                                  ),
                                ),
                                child: Center(
                                  child: Icon(Icons.music_note, size: 80),
                                ),
                              ),
                              artworkFit: BoxFit.cover,
                              artworkHeight: 350,
                              artworkWidth: 350,
                              artworkQuality: FilterQuality.high,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    children: [
                      Text(
                        song?.title ?? 'Unkown',
                        style: AppTextStyles.textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        song?.artist ?? "Unkown Artist",
                        style: AppTextStyles.textTheme.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Slider(
                        min: 0,
                        max: 1,
                        value: _isDragging
                            ? _dragValue
                            : (duration.inMilliseconds > 0
                                  ? (position.inMilliseconds /
                                        position.inMilliseconds)
                                  : 0.0),
                        onChanged: (value) => {
                          setState(() {
                            _isDragging = true;
                            _dragValue = value;
                          }),
                        },
                        onChangeEnd: (value) {
                          setState(() {
                            _isDragging = false;
                          });
                          final pos = duration * value;
                          musicService.seek(pos);
                        },
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(position),
                              style: AppTextStyles.textTheme.bodySmall,
                            ),
                            Text(
                              _formatDuration(duration),
                              style: AppTextStyles.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.shuffle)),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.skip_previous),
                      ),
                      const SizedBox(width: 20),

                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.blue, Colors.purple],
                          ),
                        ),
                        child: IconButton(
                          iconSize: 48,
                          padding: EdgeInsets.all(16),
                          onPressed: () {},
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      IconButton(onPressed: () {}, icon: Icon(Icons.skip_next)),

                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () {},
                        icon: _getRepeatIcon(musicService.repeatMode),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Favorite
                      IconButton(
                        iconSize: 30,
                        onPressed: musicService.toggleFavorite,
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                      ),

                      // Playlist
                      IconButton(
                        iconSize: 30,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.playlist_play,
                          color: Colors.white,
                        ),
                      ),

                      // Volume
                      IconButton(
                        iconSize: 30,
                        onPressed: () {},
                        icon: const Icon(Icons.volume_up, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getRepeatIcon(RepeatMode mode) {
    if (mode == RepeatMode.off) {
      return const Icon(Icons.repeat, color: Colors.grey);
    } else if (mode == RepeatMode.all) {
      return const Icon(Icons.repeat, color: Colors.blue);
    } else {
      return const Icon(Icons.repeat_one, color: Colors.blue);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
