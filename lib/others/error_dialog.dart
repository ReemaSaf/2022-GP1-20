import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'constants.dart';

// ignore: must_be_immutable
class ErrorDialog extends StatelessWidget {
  ErrorDialog({Key? key, required this.message, this.showOkButton = true})
      : super(key: key);
  final String message;
  bool showOkButton;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      elevation: 0,
      contentPadding: EdgeInsets.zero,
      title: const Center(
          child: Text("Error",
              style: TextStyle(color: blueColor, fontWeight: FontWeight.bold))),
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
        InkWell(
          onTap: () => Get.back(),
          child: Container(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: blueColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32.0),
                    bottomRight: Radius.circular(32.0)),
              ),
              child: const Text(
                "Ok",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              )),
        )
      ],
    );
  }
}

Future<void> showErrorDialog(String message) {
  return Get.dialog(ErrorDialog(
    message: message,
  ));
}
