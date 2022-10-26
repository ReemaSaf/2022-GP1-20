import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Register/signup_screen.dart';
import '../../others/already_have_an_account_acheck.dart';
import '../../others/auth_controller.dart';
import '../../others/constants.dart';
import 'forget_pass.dart';

// ignore: must_be_immutable
class LoginForm extends StatelessWidget {
  LoginForm({
    Key? key,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: blueColor,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Enter your Email.';
              }
              if (!value.isEmail) {
                return 'Please Enter a valid Email.';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: true,
              cursorColor: blueColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your Password.';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: TextButton(
                onPressed: () {
                  Get.to(ResetForm());
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: blueColor),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await AuthController().signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text);
                }
              },
              child: Text(
                "Log In".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          AlreadyHaveAnAccountCheck(
            press: () {
              Get.off(const SignUpScreen());
            },
          ),
        ],
      ),
    );
  }
}
