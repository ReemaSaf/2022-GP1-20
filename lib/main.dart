import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/Homepage/navigation.dart';
import 'package:sekkah_app/Homepage/viewmap.dart';
import 'package:sekkah_app/Welcome/components/welcome_image.dart';
import 'package:sekkah_app/Welcome/welcome_screen.dart';
import 'package:sekkah_app/splashscreen.dart';
import 'helpers/firebase_options.dart';
import 'others/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: blueColor,
            scaffoldBackgroundColor: Colors.white,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: blueColor,
                shape: const StadiumBorder(),
                maximumSize: const Size(double.infinity, 56),
                minimumSize: const Size(double.infinity, 56),
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: greenColor,
              iconColor: blueColor,
              prefixIconColor: blueColor,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide.none,
              ),
            )),
        home: AnimatedSplashScreen(
            splash: "assets/images/logosekkah.png",
            duration: 3000,
            splashTransition: SplashTransition.scaleTransition,
            backgroundColor: Colors.white,
            nextScreen: MainPage()),
      );
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<MainPage> {
  // int index = 0;
  // final screens = [
  //   const ViewMap(),
  //   const Center(child: Text('plan a route', style: (TextStyle(fontSize: 72)))),
  //   const Center(child: Text('digital card', style: (TextStyle(fontSize: 72)))),
  //   const Center(child: Text('profile', style: (TextStyle(fontSize: 72)))),
  // ];
  @override
  Widget build(BuildContext context) => Scaffold(
        body: //screens[index],
            StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return snapshot.hasData ? const ViewMap() : const WelcomeScreen();
          },
        ),
      );
  // bottomNavigationBar: NavigationBarTheme(
  //   data: NavigationBarThemeData(
  //       indicatorColor: const Color.fromARGB(126, 80, 177, 204),
  //       labelTextStyle: MaterialStateProperty.all(const TextStyle(
  //         fontSize: 12,
  //         fontWeight: FontWeight.w500,
  //         color: Color(0xff273A69),
  //       ))),
  //   child: NavigationBar(
  //       height: 60,
  //       selectedIndex: index,
  //       onDestinationSelected: (index) =>
  //           setState(() => this.index = index),
  //       backgroundColor: const Color.fromARGB(255, 255, 255, 255),
  //       // ignore: prefer_const_literals_to_create_immutables
  //       destinations: [
  //         const NavigationDestination(
  //           icon: Icon(Icons.map_outlined),
  //           label: 'Map',
  //         ),
  //         const NavigationDestination(
  //           icon: Icon(Icons.train_outlined),
  //           label: 'Plan a route',
  //         ),
  //         const NavigationDestination(
  //           icon: Icon(Icons.account_balance_wallet_outlined),
  //           label: 'Digital Card',
  //         ),
  //         const NavigationDestination(
  //           icon: Icon(Icons.person),
  //           label: 'Profile',
  //         ),
  //       ]),
  // ));
}
