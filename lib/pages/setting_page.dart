import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: const Text('Settings')
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Preferences'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              title: const Text('Preferences'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              title: const Text('Preferences'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              title: const Text('Preferences'),
              trailing: Icon(Icons.chevron_right),
            ),
            const SizedBox(height: 8,),
            ListTile(
              title: const Text('Preferences'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              title: const Text('Preferences'),
              trailing: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}
