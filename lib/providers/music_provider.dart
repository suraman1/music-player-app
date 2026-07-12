import 'package:flutter/material.dart';
import 'package:my_app/services/music_service.dart';

class MusicProvider extends ChangeNotifier {
  double _dragValue = 0.0;
  bool _isDragging = false;

  final MusicService musicService;
  MusicProvider(this.musicService);

  double get dragValue => _dragValue;
  bool get isDragging => _isDragging;

  void onChange(double val) {
    _dragValue = val;
    _isDragging = true;
    notifyListeners();
  }

  void onChangeEnd(double val) {
    _dragValue = val;
    _isDragging = false;
    final pos = musicService.duration * val;
    musicService.seek(pos);
    notifyListeners();
  }
}
