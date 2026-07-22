import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/routes/routes.dart';
import 'package:my_app/services/music_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSongs();
    });
  }

  @override
  void didChangeAppLifeCycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final musicService = context.read<MusicService>();

      await musicService.initialize();

      if (musicService.permissionGranted) {
        if (mounted) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, Routes.home);
        }
      }
    }
  }

  Future<void> _loadSongs() async {
    try {
      final musicService = context.read<MusicService>();
      await musicService.initialize();

      if (!mounted) return;

      if (musicService.permissionGranted) {
        Navigator.pushReplacementNamed(context, Routes.home);
      } else {
        if (!mounted) return;
        _showPermissionDeniedDialog();
      }
    } catch (e) {
      debugPrint('Error on splash $e');
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
            onPressed: () async {
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
