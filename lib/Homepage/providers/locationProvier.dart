// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sekkah_app/Homepage/services/locationServices.dart';

import '../../helpers/helper_fucntions.dart';

class LocationProvider extends ChangeNotifier {
  GoogleMapController? googleMapController;

  LatLng? currentLatLang;

  LocationServices locationServices = LocationServices();
  Completer<GoogleMapController> completer = Completer();

  Future<LatLng?> locationFetch(context) async {
    // dp(msg: "Location Fetch Called");
    if (await locationServices.checkForPermission(context)) {
      var location = await Location.instance.getLocation();
      currentLatLang = LatLng(location.latitude!, location.longitude!);
      animateToLocation(currentLatLang!);
      //  placePredictionList.clear();
      notifyListeners();
      return currentLatLang;
    } else {
      return null;
    }
  }

  Future<void> animateToLocation(LatLng location) async {
    dp(msg: "Camera animate");
    await googleMapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            bearing: 192.8334901395799, target: location, zoom: 14)));
  }
}
