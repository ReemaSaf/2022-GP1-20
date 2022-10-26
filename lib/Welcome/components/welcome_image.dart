import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../others/constants.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding * 1),
        Row(
          children: [
            // const Spacer(),
            Expanded(
              flex: 8,
              child: SvgPicture.asset(
                "assets/icons/logo.svg",
                width: 100.0,
                height: 300.0,
              ),
            ),
            // const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 1),
      ],
    );
  }
}
