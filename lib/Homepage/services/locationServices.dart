// ignore_for_file: file_names

import 'package:permission_handler/permission_handler.dart';

import '../../helpers/helper_fucntions.dart';

class LocationServices {
  Future<bool> checkForPermission(context) async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      showSnackBarMessage(context: context, content: "Permission is denied,");
      return false;
    } else if (status.isLimited) {
      return true;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      var status2 = await Permission.location.request();
      return status2.isGranted ? true : false;
    } else {
      return false;
    }
  }
}
