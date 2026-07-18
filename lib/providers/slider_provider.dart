import 'package:flutter/material.dart';
import 'package:my_app/services/music_service.dart';

class MusicProvider extends ChangeNotifier {
  double _dragValue = 0.0;
  bool _isDragging = false;


  double get dragValue => _dragValue;
  bool get isDragging => _isDragging;

  void onChangeStart(double val) {
    _dragValue = val;
    _isDragging = true;
    notifyListeners();
  }

  void onChange(double val) {
    _dragValue = val;
    _isDragging = true;
    notifyListeners();
  }

  void onChangeEnd(MusicService service, double val) {
    _dragValue = val;
    _isDragging = false;
    final pos = service.duration * val;
    service.seek(pos);
    notifyListeners();
  }
}
