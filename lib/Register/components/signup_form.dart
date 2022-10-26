import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/others/already_have_an_account_acheck.dart';

import '../../Login/login_screen.dart';
import '../../others/auth_controller.dart';
import '../../others/constants.dart';

// ignore: must_be_immutable
class SignUpForm extends StatelessWidget {
  SignUpForm({
    Key? key,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  // gets the value of the textfield
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            textInputAction: TextInputAction.next,
            cursorColor: blueColor,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) {
              if (val!.isEmpty) {
                return 'Please Enter your Email.';
              }
              if (!val.isEmail) {
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
            padding: const EdgeInsets.only(top: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: firstNameController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please Enter your first name.';
                }
                if (firstNameController.text.length < 3) {
                  return 'First name must be at least 3 characters.';
                }
                return null;
              },
              cursorColor: blueColor,
              decoration: const InputDecoration(
                hintText: "Your First name",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: lastNameController,
              cursorColor: blueColor,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please Enter your last name.';
                }
                if (lastNameController.text.length < 3) {
                  return 'Last name must be at least 3 characters.';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: "Your Last name",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: passwordController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please Enter your Password.';
                }
                if (passwordController.text.length < 8) {
                  return 'Password must be at least 8 characters.';
                }
                if (passwordController.text
                            .contains(RegExp(r'[0-9]')) ==
                        false ||
                    passwordController.text.contains(RegExp(r'[A-Z]')) ==
                        false ||
                    passwordController.text.contains(RegExp(r'[a-z]')) ==
                        false) {
                  return 'Password must contain at least one upperrcase letter , lowercase letter and a number.';
                } else {
                  return null;
                }
              },
              obscureText: true,
              cursorColor: blueColor,
              decoration: const InputDecoration(
                errorMaxLines: 2,
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  bool isRegistered = await AuthController()
                      .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text);

                  isRegistered
                      ? Get.snackbar(
                          'Welcome Aboard', 'Account Created Successfully',
                          backgroundColor: const Color(0xff50b2cc))
                      : null;
                }
              },
              child: Text("register".toUpperCase()),
            ),
          ),
          const SizedBox(height: 10.0),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Get.off(() => const LoginScreen());
            },
          ),
        ],
      ),
    );
  }
}
