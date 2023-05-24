// ignore_for_file: unused_import, sized_box_for_whitespace, file_names

import 'dart:async';

import 'package:flutter/material.dart';

import 'Homepage/components/user_nav.dart';
import 'Homepage/viewmap.dart';
import 'Planning/DigitalCard/DigitalCardExist.dart';
import 'constants/app_colors.dart';

class ReachedScreen extends StatefulWidget {
  const ReachedScreen({Key? key}) : super(key: key);

  @override
  State<ReachedScreen> createState() => _ReachedScreenState();
}

class _ReachedScreenState extends State<ReachedScreen> {


  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                    const NavScreen(inh:1)
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height:MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: AppColors.blueDarkColor, shape: BoxShape.circle),
              child: const Icon(Icons.done, color: Colors.white),
            ),
            const SizedBox(height: 22),
            const Text("You reached your Destination.",
                style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
          ],
        ),
      ),
    );
  }
}
