import 'package:flutter/material.dart';
import 'package:my_app/services/music_service.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:provider/provider.dart';

class SearchProvider extends ChangeNotifier {
  final TextEditingController _controller = TextEditingController();
  String _query = "";
  List<SongModel> allSongs = [];

  TextEditingController get controller => _controller;

  Iterable<SongModel> filteredSongs(BuildContext context) {
    if (allSongs.isEmpty) {
      allSongs = context.read<MusicService>().songs;
    }
    if (_query.isEmpty) return allSongs;

    final lowerQuery = _query.toLowerCase();
    return allSongs.where(
      (song) => song.title.toLowerCase().contains(lowerQuery),
    );
  }

  Iterable<SongModel> filterdArtistSongs(BuildContext context, ArtistModel artist) {
    if (allSongs.isEmpty) {
      allSongs = context.read<MusicService>().songs;
    }

    return allSongs.where(
      (song) => song.artistId == artist.id,
    );
  }

  void onChanged(BuildContext context, String val) {
    _query = val;
    notifyListeners();
  }

  void onSubmitted(BuildContext context, String val) => onChanged(context, val);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
