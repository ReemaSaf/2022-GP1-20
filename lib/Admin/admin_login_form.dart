import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../others/auth_controller.dart';
import '../../others/constants.dart';
import '../Login/components/forget_pass.dart';

// ignore: must_be_immutable
class AdminForm extends StatelessWidget {
  AdminForm({
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
                return 'Please Enter an Admin Email.';
              }
              if (!value.isEmail) {
                return 'Please Enter a valid Email format.';
              }
              if (value != "Sekkahgp@gmail.com") {
                return "Invalid Admin Email";
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "Admin email",
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
                  return 'Please enter Admin Password.';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: "Admin password",
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
        ],
      ),
    );
  }
}
