import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

enum RepeatMode { off, all, one }

class MusicService extends ChangeNotifier {
  List<SongModel> _songs = [];
  List<AlbumModel> _albums = [];
  List<ArtistModel> _artists = [];
  bool _isIntialized = false;
  bool _permissionGranted = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final OnAudioQuery _audioQuery = OnAudioQuery();

  SongModel? _currentSong;

  List<SongModel> _originalPlaylist = [];

  List<SongModel> _currentPlaylist = [];

  int _currentIndex = -1;
  bool _isShuffled = false;
  RepeatMode _repeatMode = RepeatMode.off;

  final Set<int> _favoriteSongIds = {};

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _previousVolume = 1.0;

  List<SongModel> get songs => _songs;
  List<AlbumModel> get albums => _albums;
  bool get isInitialized => _isIntialized;
  bool get permissionGranted => _permissionGranted;

  SongModel? get currentSong => _currentSong;
  List<SongModel> get currentPlaylist => _currentPlaylist;
  List<ArtistModel> get artists => _artists;
  int get currentIndex => _currentIndex;
  bool get isShuffled => _isShuffled;
  RepeatMode get repeatMode => _repeatMode;

  bool get isFavorite =>
      _currentSong != null && _favoriteSongIds.contains(_currentSong!.id);

  Duration get position => _position;
  Duration get duration => _duration;

  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  bool get isPlaying => _audioPlayer.playing;
  double get previousVolume => _previousVolume;
  bool get isMute => _audioPlayer.volume == 0;
  Set<int> get favoriteSongIds => _favoriteSongIds;

  MusicService() {
    _audioPlayer.playerStateStream.listen((state) {
      notifyListeners();

      if (state.processingState == ProcessingState.completed) {
        _onSongComplete();
      }
    });

    _audioPlayer.durationStream.listen((duration) {
      _duration = duration ?? Duration.zero;
      notifyListeners();
    });

    _audioPlayer.positionStream.listen((position) {
      _position = position;
    });
  }

  Future<void> initialize() async {
    if (_isIntialized) return;

    try {
      final hasPermission = await _audioQuery.permissionsStatus();

      if (!hasPermission) {
        final requested = await _audioQuery.permissionsRequest();

        if (!requested) {
          _permissionGranted = false;
          _isIntialized = true;
          notifyListeners();
          return;
        }
      }

      _permissionGranted = true;
      notifyListeners();

      _songs = await _audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );

      _albums = await _audioQuery.queryAlbums(
        sortType: AlbumSortType.ARTIST,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );

      _artists = await _audioQuery.queryArtists(
        sortType: ArtistSortType.ARTIST,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );

      _isIntialized = true;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Initialization error: $e");
      }
      _isIntialized = true;
      notifyListeners();
    }
  }

  Future<void> playSong(SongModel song, {List<SongModel>? playlist}) async {
    try {
      if (playlist != null) {
        _originalPlaylist = playlist;
        _currentPlaylist = _isShuffled ? _shuffledCopy(playlist) : playlist;
      }

      _currentIndex = _currentPlaylist.indexWhere((s) => s.id == song.id);
      if (_currentIndex == -1) _currentIndex = 0;

      _currentSong = _currentPlaylist.isNotEmpty
          ? _currentPlaylist[_currentIndex]
          : song;

      final uri = Uri.parse(song.uri ?? '');
      await _audioPlayer.setAudioSource(
        AudioSource.uri(uri),
        initialPosition: Duration.zero,
      );

      await _audioPlayer.play();

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error playing song $e');
      }
    }
  }

  Future<void> playAt(int index) async {
    if (index < 0 || index >= _currentPlaylist.length) return;
    await playSong(_currentPlaylist[index]);
  }

  Future<void> playPause(SongModel song) async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else if (_currentSong?.id == song.id) {
      await _audioPlayer.play();
    } else {
      await playSong(song);
    }
    notifyListeners();
  }

  Future<void> playAll(List<SongModel> playlist) async {
    if (playlist.isEmpty) return;
    _originalPlaylist = playlist;
    _currentPlaylist = _isShuffled ? _shuffledCopy(playlist) : playlist;
    await playAt(0);
  }

  Future<void> playNext() async {
    if (_currentPlaylist.isEmpty) return;

    if (_repeatMode == RepeatMode.one) {
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play();
      return;
    }

    final atEnd = _currentIndex >= _currentPlaylist.length - 1;
    if (atEnd && _repeatMode == RepeatMode.off) {
      await _audioPlayer.pause();
      await _audioPlayer.seek(Duration.zero);
      return;
    }

    _currentIndex = (_currentIndex + 1) % _currentPlaylist.length;
    await playSong(_currentPlaylist[_currentIndex]);
  }

  Future<void> playPrevious() async {
    if (_currentPlaylist.isEmpty) return;

    if (_position > const Duration(seconds: 3)) {
      await _audioPlayer.seek(Duration.zero);
      return;
    }

    _currentIndex =
        (_currentIndex - 1 + _currentPlaylist.length) % _currentPlaylist.length;
    await playSong(_currentPlaylist[_currentIndex]);
  }

  Future<void> _onSongComplete() async {
    if (_repeatMode == RepeatMode.one) {
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play();
      return;
    }

    final atEnd = _currentIndex >= _currentPlaylist.length - 1;
    if (atEnd && _repeatMode == RepeatMode.off) {
      return;
    }

    await playNext();
  }

  void toggleShuffle() {
    _isShuffled = !_isShuffled;

    if (_originalPlaylist.isEmpty) {
      notifyListeners();
      return;
    }

    if (_isShuffled) {
      _currentPlaylist = _shuffledCopy(_originalPlaylist);
    } else {
      _currentPlaylist = List.of(_originalPlaylist);
    }

    if (_currentSong != null) {
      _currentIndex = _currentPlaylist.indexWhere(
        (s) => s.id == _currentSong!.id,
      );
      if (_currentIndex == -1) _currentIndex = 0;
    }

    notifyListeners();
  }

  List<SongModel> _shuffledCopy(List<SongModel> source) {
    final copy = List<SongModel>.of(source);
    copy.shuffle(Random());
    return copy;
  }

  void toggleRepeatMode() {
    switch (_repeatMode) {
      case RepeatMode.off:
        _repeatMode = RepeatMode.all;
        break;
      case RepeatMode.all:
        _repeatMode = RepeatMode.one;
        break;
      case RepeatMode.one:
        _repeatMode = RepeatMode.off;
        break;
    }
    notifyListeners();
  }

  List<SongModel> getAllSongsFromAlbum(AlbumModel album) {
    return _songs.where((song) => song.albumId == album.id).toList();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> toggleVolume() async {
    if (isMute) {
      await _audioPlayer.setVolume(
        _previousVolume == 0 ? 1.0 : _previousVolume,
      );
    } else {
      _previousVolume = _audioPlayer.volume;
      await _audioPlayer.setVolume(0.0);
    }
    notifyListeners();
  }

  void toggleFavorite() {
    if (_currentSong == null) return;
    final id = _currentSong!.id;
    if (_favoriteSongIds.contains(id)) {
      _favoriteSongIds.remove(id);
    } else {
      _favoriteSongIds.add(id);
    }
    notifyListeners();
  }

  bool isSongFavorite(int songId) => _favoriteSongIds.contains(songId);

  void addSongToPlaylist(SongModel song) {
    _currentPlaylist.clear();
    _currentPlaylist.add(song);
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
