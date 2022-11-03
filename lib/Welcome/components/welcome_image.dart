import 'package:flutter/material.dart';
import '../../others/constants.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding * 7.0),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 16,
              child: Image.asset(
                "assets/images/splash.png",
                height: 265.0,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 0.5),
      ],
    );
  }
}
