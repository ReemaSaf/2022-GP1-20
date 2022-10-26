import 'package:flutter/material.dart';
import 'viewmap.dart';
//import '/Welcome/welcome_screen.dart'; ...

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int index = 0;

  final screens = [
    ViewMap(),
    Center(child: Text('plan a route', style: (TextStyle(fontSize: 72)))),
    Center(child: Text('digital card', style: (TextStyle(fontSize: 72)))),
    Center(child: Text('profile', style: (TextStyle(fontSize: 72)))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[index],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              indicatorColor: Color.fromARGB(126, 80, 177, 204),
              labelTextStyle: MaterialStateProperty.all(TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xff273A69),
              ))),
          child: NavigationBar(
              height: 60,
              selectedIndex: index,
              onDestinationSelected: (index) =>
                  setState(() => this.index = index),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.map_outlined),
                  label: 'Map',
                ),
                NavigationDestination(
                  icon: Icon(Icons.train_outlined),
                  label: 'Plan a route',
                ),
                NavigationDestination(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  label: 'Digital Card',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ]),
        ));
  }
}
