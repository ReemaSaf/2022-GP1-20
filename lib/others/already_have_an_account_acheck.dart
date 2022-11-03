import 'package:flutter/material.dart';

import 'constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function? press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Dont have an Account ? " : "Already have an Account ? ",
          style: const TextStyle(color: blueColor, fontSize: 14),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? "Register" : "Log In",
            style: const TextStyle(
              color: blueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
