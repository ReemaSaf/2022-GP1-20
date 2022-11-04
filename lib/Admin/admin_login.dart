import 'package:flutter/material.dart';
import 'package:sekkah_app/Admin/admin_login_form.dart';
import 'package:sekkah_app/Admin/admin_login_screen_top_img.dart';
import 'package:sekkah_app/others/background.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Background(
      child: MobileLoginScreen(),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const AdminLoginScreenTopImage(),
          Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 8,
                child: AdminForm(),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
