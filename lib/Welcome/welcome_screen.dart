import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/others/background.dart';
import '../Admin/admin_login.dart';
import '../others/constants.dart';
import 'components/login_signup_btn.dart';
import 'components/welcome_image.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Background(
      child: SingleChildScrollView(
        child: SafeArea(
          child: MobileWelcomeScreen(),
        ),
      ),
    );
  }
}

class MobileWelcomeScreen extends StatelessWidget {
  const MobileWelcomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(),
              const SizedBox(
                width: 32,
              ),
              Column(
                children: [
                  IconButton(
                    iconSize: 70,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Get.to(const AdminLoginScreen());
                    },
                    style: IconButton.styleFrom(
                        backgroundColor: greenColor, elevation: 0),
                    icon: const Icon(Icons.admin_panel_settings_rounded,
                        color: blueColor),
                  ),
                  Text(
                    "Admin".toUpperCase(),
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      color: blueColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  )
                ],
              ),
              Spacer(),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        const WelcomeImage(),
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: LoginAndSignupBtn(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
