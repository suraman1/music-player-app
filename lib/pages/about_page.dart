import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: const Text('About'),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This appliction was made for personal use.'),
            Text(
              'version 1.0.0',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'last updated: 2026-07-11',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ]
        )
      )
    );
  }
}