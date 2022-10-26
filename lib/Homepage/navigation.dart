import 'package:flutter/material.dart';
import 'viewmap.dart';
//import '/Welcome/welcome_screen.dart'; ...

class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int index = 0;

  final screens = [
    const ViewMap(),
    const Center(child: Text('plan a route', style: (TextStyle(fontSize: 72)))),
    const Center(child: Text('digital card', style: (TextStyle(fontSize: 72)))),
    const Center(child: Text('profile', style: (TextStyle(fontSize: 72)))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[index],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              indicatorColor: const Color.fromARGB(126, 80, 177, 204),
              labelTextStyle: MaterialStateProperty.all(const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xff273A69),
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
                  icon: Icon(Icons.train_outlined),
                  label: 'Plan a route',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  label: 'Digital Card',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ]),
        ));
  }
}
