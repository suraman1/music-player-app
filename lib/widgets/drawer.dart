import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(8)
        )
      ),
      child: SafeArea(
  
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Bob'),
              accountEmail: const Text('bob@gmail.com'),
              currentAccountPicture: CircleAvatar(radius: 28, backgroundColor: Colors.yellow),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16)
                )
              ),
            ),
            Expanded(
              child:
                Column(
                  children: [
                  
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: const Text('Setting'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    ListTile(
                      leading: Icon(Icons.info),
                      title: const Text('About'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    ListTile(
                    leading: Icon(Icons.dark_mode),
                    title: const Text('Dark Mode'),
                    trailing: Switch(value: false, onChanged: (isDark) => {
                     setState(() {
                       
                     })
                   }),
                  ),
                  ListTile(
                    leading: Icon(Icons.star),
                    title: const Text('Rate us'),
                  ),
                  ],
                ),
            ),


            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('version 1.0.0'),
                  const Text('built 2026-06-01')
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
