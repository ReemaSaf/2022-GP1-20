// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Homepage/components/admin_nav.dart';
import '../../Homepage/components/user_nav.dart';

class UserStateChecker extends StatelessWidget {
  UserStateChecker({super.key});
  String? currentEmail = FirebaseAuth.instance.currentUser!.email;
  bool isAnnonymous = FirebaseAuth.instance.currentUser!.isAnonymous;
  String adminEmail = "sekkahgp@gmail.com";
  bool get isAdminEmail => isAnnonymous ? false : currentEmail == adminEmail;

  @override
  Widget build(BuildContext context) {
    return isAdminEmail ? const AdminNavScreen() : const NavScreen();
  }
}
