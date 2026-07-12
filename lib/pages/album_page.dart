import 'package:flutter/material.dart';
import 'package:my_app/routes/routes.dart';
import 'package:my_app/services/music_service.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:provider/provider.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key});
  @override
  Widget build(BuildContext context) {
    final albums = context.read<MusicService>().albums;

    if (albums.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.album, size: 64, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              'No Albums found',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const Text(
              'Add music files to your device',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: albums.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.75,
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16
      ),
      
      itemBuilder: (context, index) {
        final album = albums[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.albumPlay, arguments: album);
          },
          child: Column(
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: ClipRRect (
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  child: QueryArtworkWidget(
                    id: album.id,
                    type: ArtworkType.ALBUM,
                    nullArtworkWidget: Container(
                      child: const Icon(Icons.album, size: 64),
                    ),
                  ),
                ),
              ),
          
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      album.album,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      album.artist ?? "Unkown Artist",
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${album.numOfSongs} songs',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}