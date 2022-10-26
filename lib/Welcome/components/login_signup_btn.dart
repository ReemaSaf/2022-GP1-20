import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/others/auth_controller.dart';

import '../../Login/login_screen.dart';
import '../../Register/signup_screen.dart';
import '../../others/constants.dart';

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Get.to(const LoginScreen());
          },
          child: Text(
            "Log In".toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Get.to(const SignUpScreen());
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: greenColor, elevation: 0),
          child: Text(
            "Register".toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
            onPressed: () async {
              await AuthController().signUpAsGuest();
            },
            child: const Text(
              "Continue As Guest",
              style: TextStyle(
                color: greyColor,
                decoration: TextDecoration.underline,
                fontSize: 16,
              ),
            )),
      ],
    );
  }
}
