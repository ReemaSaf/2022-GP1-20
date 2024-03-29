// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/Homepage/viewmap.dart';
import 'package:sekkah_app/Planning/DigitalCard/DigitalCard.dart';
import 'package:sekkah_app/Planning/plan_route.dart';
import 'package:sekkah_app/Profile/profile_screen.dart';
import 'package:sekkah_app/helpers/dialog_alert.dart';
import 'package:sekkah_app/others/auth_controller.dart';
import 'package:sekkah_app/others/constants.dart';

import '../../Tickets/History.dart';

class NavScreen extends StatefulWidget {
  final int inh;
  const NavScreen({super.key, required this.inh});

  @override
  // ignore: library_private_types_in_public_api
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  late int index = widget.inh;

  final screens = [
    const ViewMap(),
    const PlanARoute(),
    const DigitalCard(),
    const HistoryTickets(),
    ProfileScreen(),
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
              onDestinationSelected: (currentIndex) {
                setState(() => index = currentIndex);
                if (FirebaseAuth.instance.currentUser!.isAnonymous &&
                    (index == 3)) {
                  showConfirmationDialog(
                      heading: "Alert",
                      message: "You must register to view tickets.",
                      okText: "Register",
                      onPressedOk: () {
                        Get.back();
                        AuthController().signOut();
                      },
                      cancel: () {
                        Get.back();
                        1.seconds.delay().then((value) {
                          setState(() {
                            index = 0;
                          });
                        });
                      });
                }
                if (FirebaseAuth.instance.currentUser!.isAnonymous &&
                    (index == 4)) {
                  showConfirmationDialog(
                      heading: "Alert",
                      message: "You must register to access your profile.",
                      okText: "Register",
                      onPressedOk: () {
                        Get.back();
                        AuthController().signOut();
                      },
                      cancel: () {
                        Get.back();
                        1.seconds.delay().then((value) {
                          setState(() {
                            index = 0;
                          });
                        });
                      });
                }
              },
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              // ignore: prefer_const_literals_to_create_immutables
              destinations: [
                const NavigationDestination(
                  icon: Icon(
                    Icons.map_outlined,
                    color: Color(0xFF273B68),
                  ),
                  label: 'Map',
                ),
                const NavigationDestination(
                  icon: Icon(
                    Icons.train_outlined,
                    color: Color(0xFF273B68),
                  ),
                  label: 'Plan Route',
                ),
                const NavigationDestination(
                  icon: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Color(0xFF273B68),
                  ),
                  label: 'Digital Card',
                ),
                const NavigationDestination(
                  icon: Icon(
                    Icons.confirmation_number_outlined,
                    color: Color(0xFF273B68),
                  ),
                  label: 'Tickets',
                ),
                const NavigationDestination(
                  icon: Icon(
                    Icons.person,
                    color: Color(0xFF273B68),
                  ),
                  label: 'Profile',
                ),
              ]),
        ));
  }
}
