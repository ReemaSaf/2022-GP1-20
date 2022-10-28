import 'package:flutter/material.dart';
import 'package:sekkah_app/Homepage/navigation.dart';
import 'package:sekkah_app/Homepage/viewmap.dart';
import 'package:sekkah_app/main.dart';
import 'package:sekkah_app/others/background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateview();
  }

  _navigateview() async {
    await Future.delayed(Duration(microseconds: 1500), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: ((context) => MainPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
