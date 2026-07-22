import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_app/providers/profile_provider.dart';
import 'package:my_app/providers/theme_provider.dart';
import 'package:my_app/routes/routes.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Consumer<ProfileProvider>(
              builder: (_, profileProvider, _) {
                profileProvider.loadProfile();
                return GestureDetector(
                  onLongPress: () async {
                    await profileProvider.pickImage();
                  },
                  child: UserAccountsDrawerHeader(
                    accountName: Text(
                      'Bob',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    accountEmail: Text(
                      'bob@gmail.com',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    currentAccountPicture: CircleAvatar(
                      radius: 28,
                      backgroundImage: profileProvider.imagePath != null
                          ? FileImage(File(profileProvider.imagePath!))
                          : null,
                      backgroundColor: profileProvider.imagePath != null
                          ? Colors.amber
                          : null,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text(
                      'Settings',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(context, Routes.settings),
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text(
                      'About',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(context, Routes.about),
                  ),
                  ListTile(
                    leading: Icon(Icons.dark_mode),
                    title: Text(
                      'Dark Mode',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (isDark) => {themeProvider.toggleTheme()},
                    ),
                    onTap: () => themeProvider.toggleTheme(),
                  ),
                  ListTile(
                    leading: Icon(Icons.star),
                    title: Text(
                      'Rate us',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'version 1.0.0',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'last updated: 2026-07-11',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
