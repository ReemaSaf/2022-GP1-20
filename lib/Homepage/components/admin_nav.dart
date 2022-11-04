// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sekkah_app/Homepage/viewmap.dart';
import 'package:sekkah_app/others/constants.dart';

class AdminNavScreen extends StatefulWidget {
  const AdminNavScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminNavScreenState createState() => _AdminNavScreenState();
}

class _AdminNavScreenState extends State<AdminNavScreen> {
  int index = 0;

  final screens = [
    const ViewMap(),
    const Center(child: Text('Update', style: (TextStyle(fontSize: 72)))),
    const Center(child: Text('Announce', style: (TextStyle(fontSize: 72)))),
    const Center(child: Text('Profile', style: (TextStyle(fontSize: 72)))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[index],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              indicatorColor: greenColor,
              labelTextStyle: MaterialStateProperty.all(const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: blueColor,
              ))),
          child: NavigationBar(
              height: 60,
              selectedIndex: index,
              onDestinationSelected: (index) =>
                  setState(() => this.index = index),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              // ignore: prefer_const_literals_to_create_immutables
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.map_outlined),
                  label: 'Map',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.update),
                  label: 'Update',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.notification_add),
                  label: 'Announce',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.manage_accounts),
                  label: 'Profile',
                ),
              ]),
        ));
  }
}
