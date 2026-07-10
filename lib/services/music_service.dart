import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

enum RepeatMode { on, off, all }

class MusicService extends ChangeNotifier {
  List<SongModel> _songs = [];
  List<AlbumModel> _albums = [];
  bool _isIntialized = false;
  bool _permissionGranted = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final OnAudioQuery audioQuery = OnAudioQuery();

  SongModel? _currentSong;
  List<SongModel> _currentPlaylist = [];
  int _currentIndex = -1;
  bool _isShuffled = false;
  bool _isRepeated = false;
  RepeatMode _repeatMode = RepeatMode.off;

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

  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<double> get volumeStream => _audioPlayer.volumeStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<bool> get playingStream => _audioPlayer.playingStream;

  Future<void> initialize() async {
    if (_isIntialized) return;
    try {
      PermissionStatus status = await Permission.audio.request();

      if (status.isDenied) {
        _isIntialized = true;
        notifyListeners();
        return;
      }

      _permissionGranted = true;

      _songs = await audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );

      _albums = await audioQuery.queryAlbums(
        sortType: AlbumSortType.ARTIST,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );

      if (kDebugMode) {
        debugPrint('Loaded songs ${_songs.length}');
        debugPrint('Loaded albums ${_albums.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading songs $e');
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

  Future<void> playPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.stop();
    } else {
      if (_currentSong == null && _songs.isNotEmpty) {
        await playSong(_songs[0]);
      } else {
        await _audioPlayer.play();
      }
    }
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> setVolume(double vol) async {
    await _audioPlayer.setVolume(vol.clamp(0, 1));
    notifyListeners();
  }

  Future<void> toggleFavorite() async {}

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
