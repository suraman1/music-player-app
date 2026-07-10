import 'package:flutter/material.dart';
import 'package:my_app/routes/routes.dart';
import 'package:my_app/services/music_service.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final MusicService musicService = MusicService();
  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final musicService = context.read<MusicService>();
    await musicService.initialize();

    if (!mounted) return;

    if (musicService.permissionGranted) {
      Navigator.pushReplacementNamed(context, Routes.home);
    } else {
      if (!mounted) return;
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Permission required'),
        content: const Text('Music player needs access to your audio files.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _loadSongs();
            },
            child: const Text('Try Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note, size: 80),
            SizedBox(height: 20),
            Text(
              'Music Player',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
