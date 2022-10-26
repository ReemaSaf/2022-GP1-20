import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../others/constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: blueColor,
                )),
            const Spacer(),
            const Text(
              "LOG IN",
              style: TextStyle(
                  color: blueColor, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Spacer(),
            const IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.transparent,
                )),
          ],
        ),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 6,
              child: SvgPicture.asset("assets/icons/user.svg"),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
