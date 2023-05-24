import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sekkah_app/constants/app_colors.dart';

import 'Homepage/components/user_nav.dart';
import 'Homepage/viewmap.dart';


class ReachedScreen extends StatefulWidget {
  const ReachedScreen({Key? key}) : super(key: key);

  @override
  State<ReachedScreen> createState() => _ReachedScreenState();
}

class _ReachedScreenState extends State<ReachedScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                    NavScreen(inh:1)
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
            const Text("You Have Reach At Your Destination",
                style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
          ],
        ),
      ),
    );
  }
}
