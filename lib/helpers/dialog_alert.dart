import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../others/constants.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog(
      {Key? key,
      this.onPressedOk,
      this.cancel,
      this.textColor = const Color(0xFFEA0101),
      required this.heading,
      required this.message,
      required this.okText})
      : super(key: key);
  final Color textColor;
  final VoidCallback? onPressedOk;
  final VoidCallback? cancel;
  final String heading;
  final String message;
  final String okText;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      elevation: 0,
      contentPadding: EdgeInsets.zero,
      title: Center(
          child: Text(heading,
              style: const TextStyle(
                  color: blueColor, fontWeight: FontWeight.bold))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 9,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black)),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
      actionsPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      actions: [
        Container(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: blueColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32.0),
                  bottomRight: Radius.circular(32.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: cancel,
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )),
                const SizedBox(
                  width: 25,
                ),
                TextButton(
                    onPressed: onPressedOk,
                    child: Text(
                      okText,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ))
              ],
            ))
      ],
    );
  }
}

void dismissDialog() {
  Get.back();
}

Future<void> showConfirmationDialog({
  required String heading,
  required String message,
  required String okText,
  required VoidCallback? onPressedOk,
  required VoidCallback? cancel,
  Color? color,
}) async {
  await Get.dialog(
      ConfirmationDialog(
        heading: heading,
        message: message,
        okText: okText,
        onPressedOk: onPressedOk,
        cancel: cancel,
        textColor: color ?? Colors.red,
      ),
      barrierDismissible: false);
}
