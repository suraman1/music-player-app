import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_app/providers/slider_provider.dart';
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
  late MusicService _musicService;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _musicService = context.read<MusicService>();
    _musicService.addListener(_syncRotation);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncRotation());
  }

  void _syncRotation() {
    if (!mounted) return;
    final isPlaying = _musicService.isPlaying;
    if (isPlaying && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!isPlaying && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _musicService.removeListener(_syncRotation);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final musicService = context.watch<MusicService>();
    final SongModel? song = musicService.currentSong;

    if (song == null) {
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

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
      
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.3),
                        spreadRadius: 20,
                        blurRadius: 30,
                      ),
                    ],
                  ),
                  child: AnimatedBuilder(

                  animation: _controller,
                  
                    child: QueryArtworkWidget(
                      id: song.id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.blue, Colors.purple],
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.music_note, size: 80),
                        ),
                      ),
                      artworkFit: BoxFit.cover,
                      artworkHeight: 350,
                      artworkWidth: 350,
                      artworkQuality: FilterQuality.high,
                    ),
                    builder: (_, child) {
                      return Transform.rotate(
                        angle: _controller.value * 2 * pi,
                        child: child,
                      );
                    },
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  Text(
                    song.title,
                    style: AppTextStyles.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artist ?? "Unknown Artist",
                    style: AppTextStyles.textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  StreamBuilder<Duration>(
                    stream: musicService.positionStream,
                    builder: (_, snapShot) {
                      final position = snapShot.data ?? Duration.zero;
                      return Consumer<MusicProvider>(
                        builder: (_, slider, __) {
                          return Slider(
                            min: 0,
                            max: 1,
                            value: slider.isDragging
                                ? slider.dragValue
                                : (musicService.duration.inMilliseconds > 0
                                    ? (position.inMilliseconds /
                                            musicService
                                                .duration.inMilliseconds)
                                        .clamp(0.0, 1.0)
                                    : 0.0),
                            
                            onChangeStart: (value) {
                              slider.onChangeStart(value);
                            },
                            onChanged: (value) {
                              slider.onChange(value);
                            },
                            onChangeEnd: (value) {
                              slider.onChangeEnd(musicService, value);
                            },
                          );
                        },
                      );
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StreamBuilder<Duration>(
                          stream: musicService.positionStream,
                          builder: (_, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            return Text(
                              _formatDuration(position),
                              style: AppTextStyles.textTheme.bodySmall,
                            );
                          },
                        ),
                        StreamBuilder<Duration?>(
                          stream: musicService.durationStream,
                          builder: (_, snapShot) {
                            final duration = snapShot.data ?? Duration.zero;
                            return Text(
                              _formatDuration(duration),
                              style: AppTextStyles.textTheme.bodySmall,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Selector<MusicService, bool>(
                    selector: (_, music) => music.isShuffled,
                    builder: (_, isShuffled, __) {
                      return IconButton(
                        onPressed: () {
                          musicService.toggleShuffle();
                        },
                        icon: Icon(
                          Icons.shuffle,
                          color: isShuffled ? Colors.blue : Colors.grey,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () async {
                      await musicService.playPrevious();
                    },
                    icon: const Icon(Icons.skip_previous, size: 32),
                  ),

                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                      ),
                    ),
                    child: IconButton(
                      iconSize: 48,
                      padding: const EdgeInsets.all(16),
                      onPressed: () async {
                        await musicService.playPause(song);
                      },
                      icon: Selector<MusicService, bool>(
                        selector: (_, music) => music.isPlaying,
                        builder: (_, isPlaying, __) {
                          return Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                          );
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await musicService.playNext();
                    },
                    icon: const Icon(Icons.skip_next, size: 32),
                  ),

                  Selector<MusicService, RepeatMode>(
                    selector: (_, music) => music.repeatMode,
                    builder: (_, mode, __) {
                      return IconButton(

                        onPressed: () {
                          musicService.toggleRepeatMode();
                        },
                        icon: _getRepeatIcon(mode),
                      );
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Favorite
                  Selector<MusicService, bool>(
                    selector: (_, music) => music.isFavorite,
                    builder: (_, isFavorite, __) {
                      return IconButton(
                        iconSize: 30,
                        onPressed: musicService.toggleFavorite,
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                      );
                    },
                  ),

                  // Playlist
                  IconButton(
                    iconSize: 30,
                    onPressed: () {},
                    icon: const Icon(Icons.playlist_play),
                  ),

                  // Volume
                  Selector<MusicService, bool>(
                    selector: (_, music) => music.isMute,
                    builder: (_, isMute, __) {
                      return IconButton(
                        iconSize: 30,
                        onPressed: () {
                          musicService.toggleVolume();
                        },
                        icon: isMute
                            ? const Icon(Icons.volume_mute)
                            : const Icon(Icons.volume_up),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getRepeatIcon(RepeatMode mode) {
    switch (mode) {
      case RepeatMode.off:
        return const Icon(Icons.repeat, color: Colors.grey);
      case RepeatMode.all:
        return const Icon(Icons.repeat, color: Colors.blue);
      case RepeatMode.one:
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