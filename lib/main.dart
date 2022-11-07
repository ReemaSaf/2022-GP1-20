import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/Welcome/welcome_screen.dart';
import 'Welcome/components/state_checker.dart';
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
            splash: "assets/images/splash.png",
            duration: 3000,
            splashTransition: SplashTransition.scaleTransition,
            backgroundColor: Colors.white,
            splashIconSize: 145,
            centered: true,
            nextScreen: const MainPage()),
      );
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return snapshot.hasData
                ? UserStateChecker()
                : const WelcomeScreen();
          },
        ),
      );
}
