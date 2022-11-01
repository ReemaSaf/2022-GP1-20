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
        const SizedBox(height: defaultPadding * 1.5),
        Row(
          children: [
            // const Spacer(),
            Expanded(
              flex: 8,
              child: Image.asset(
                "assets/images/Perfect.png",
                height: 320.0,
              ),
            ),
            // const Spacer(),
          ],
        ),
        // const SizedBox(height: defaultPadding * 0.3),
      ],
    );
  }
}
