import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  final String backGroundImage = "assets/images/HOME.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: double.infinity,
          height: Get.height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(backGroundImage), fit: BoxFit.cover),
          ),
          child: SafeArea(child: child),
        )
        // body: SizedBox(
        //   width: double.infinity,
        //   height: Get.height,
        //   child: Stack(
        //     alignment: Alignment.center,
        //     children: <Widget>[
        //       Image.asset(
        //         backGroundImage,
        //         width: 120,
        //       ),
        //       ,
        //     ],
        //   ),
        // ),
        );
  }
}
