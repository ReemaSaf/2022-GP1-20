import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:sekkah_app/others/auth_controller.dart';

import '../../others/constants.dart';

// ignore: must_be_immutable
class ResetForm extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var context;

  ResetForm({
    Key? key,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  final String backGroundImage = "assets/images/sekkah-Bg.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: Get.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(backGroundImage), fit: BoxFit.cover),
        ),
        child: SafeArea(
            child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: blueColor,
                    )),
              ),
              const SizedBox(
                height: 100,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 60.0),
                child: Text(
                  'Forgot Password ?',
                  style: TextStyle(
                      color: greenColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 32),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding + 4),
                child: Text(
                  'Please enter your email to receive a password reset link.',
                  style: TextStyle(
                      color: blueColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding, horizontal: defaultPadding),
                child: TextFormField(
                  controller: emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: blueColor,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email.';
                    }
                    if (!value.isEmail) {
                      return 'Please enter a valid email.';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "Your email",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: defaultPadding * 0.1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 115.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool isSent = await AuthController()
                          .sendPasswordResetEmail(email: emailController.text);
                      if (isSent) {
                        Get.back();
                        Get.snackbar('Success',
                            'Password Reset link has been sent, Please check your Email.',
                            backgroundColor: greenColor,
                            colorText: blueColor,
                            duration: 6.seconds);
                      }
                    }
                  },
                  child: Text("Reset Password".toUpperCase()),
                ),
              ),
              const Spacer(),
            ],
          ),
        )),
      ),
    );
  }
}
