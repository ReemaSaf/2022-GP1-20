// ignore_for_file: file_names

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../others/constants.dart';
import '../../others/error_handelling.dart';

class LocationServices {
  Future<bool> checkForPermission(context) async {
    String errorMessage =
        ErrorHandelling.getMessageFromErrorCode(errorCode: 'location');

    var status = await Permission.location.request();
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      showErrorDialogg(errorMessage);
      return false;
    } else if (status.isLimited) {
      return true;
    } else if (status.isPermanentlyDenied) {
      showErrorDialogg(errorMessage);
      var status2 = await Permission.location.request();
      return status2.isGranted ? true : false;
    } else {
      return false;
    }
  }
}

// ignore: must_be_immutable
class ErrorDialogg extends StatelessWidget {
  ErrorDialogg({Key? key, required this.message, this.showOkButton = true})
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
        Container(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: blueColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32.0),
                  bottomRight: Radius.circular(32.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: const Text(
                    "Close",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                InkWell(
                  onTap: () => openAppSettings(),
                  child: const Text(
                    "Open Settings",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ))
      ],
    );
  }
}

Future<void> showErrorDialogg(String message) {
  return Get.dialog(ErrorDialogg(
    message: message,
  ));
}
