// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls, avoid_print

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sekkah_app/Homepage/services/locationServices.dart';
import '../../helpers/helper_function.dart';

class LocationProvider extends ChangeNotifier {
  GoogleMapController? googleMapController;

  LatLng? currentLatLang;

  LocationServices locationServices = LocationServices();
  Completer<GoogleMapController> completer = Completer();

  Future<LatLng?> locationFetch(context) async {
    if (await locationServices.checkForPermission(context)) {
      var location = await Location.instance.getLocation();
      currentLatLang = LatLng(location.latitude!, location.longitude!);
      animateToLocation(currentLatLang!);

      notifyListeners();
      return currentLatLang;
    } else {
      return null;
    }
  }

  Stream<LocationData> getCurrentLoction(context) async* {
    if (currentLatLang == null) {
      await locationFetch(context);
    }
    if (await locationServices.checkForPermission(context)) {
      final currentPosition = Location.instance.onLocationChanged;

      yield* currentPosition;
    } else {
      yield* const Stream.empty();
    }
  }

  Future<void> animateToLocation(LatLng location) async {
    final GoogleMapController controller = await completer.future;
    dp(msg: "Camera animate");
    await controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            bearing: 192.8334901395799, target: location, zoom: 14)));
  }

  Future<double> distanceBetween(
      GeoPoint endLocation, LatLng? currentPosition) async {
    final double distance = Geolocator.distanceBetween(
            endLocation.latitude,
            endLocation.longitude,
            currentPosition!.latitude,
            currentPosition.longitude) /
        1000;

    print(distance);

    return distance;

  }
}
