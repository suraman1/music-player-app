import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

enum RepeatMode { on, off, all }

class MusicService extends ChangeNotifier {
  List<SongModel> _songs = [];
  List<AlbumModel> _albums = [];
  bool _isIntialized = false;
  bool _permissionGranted = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final OnAudioQuery _audioQuery = OnAudioQuery();

  SongModel? _currentSong;
  List<SongModel> _currentPlaylist = [];
  int _currentIndex = -1;
  bool _isShuffled = false;
  bool _isRepeated = false;
  RepeatMode _repeatMode = RepeatMode.off;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _previousVolume = 0;

  List<SongModel> get songs => _songs;
  List<AlbumModel> get albums => _albums;
  bool get isInitialized => _isIntialized;
  bool get permissionGranted => _permissionGranted;

  SongModel? get currentSong => _currentSong;
  List<SongModel> get currentPlaylist => _currentPlaylist;
  int get currentIndex => _currentIndex;
  bool get isShuffled => _isShuffled;
  bool get isRepeated => _isRepeated;
  RepeatMode get repeatMode => _repeatMode;

  Duration get position => _position;
  Duration get duration => _duration;

  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  bool get isPlaying => _audioPlayer.playing;
  double get previousVolume => _audioPlayer.volume;
  bool get isMute => _audioPlayer.volume == 0;

  MusicService() {
    _audioPlayer.playerStateStream.listen((_) {
      notifyListeners();
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
      _currentPlaylist = playlist ?? _songs;
      _currentIndex = _currentPlaylist.indexWhere((s) => s.id == song.id);

      if (_currentIndex == -1) _currentIndex = 0;

      _currentSong = _currentPlaylist[_currentIndex];
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
    await playSong(_currentPlaylist[index], playlist: _currentPlaylist);
  }

  Future<void> playPause(SongModel song) async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      _currentSong = song;
      await _audioPlayer.play();
    }
    notifyListeners();
  }

  Future<void> playAll(List<SongModel> songs) async {}

  List<SongModel> getAllSongsFromAlbum(AlbumModel album) {
    return _songs.where((song) => song.albumId == album.id).toList();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> toggleVolume() async {
    if (isMute) {
      await _audioPlayer.setVolume(_previousVolume);
    } else {
      _previousVolume = _audioPlayer.volume;
      _audioPlayer.setVolume(0.0);
    }
    notifyListeners();
  }

  Future<void> toggleFavorite() async {}

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
