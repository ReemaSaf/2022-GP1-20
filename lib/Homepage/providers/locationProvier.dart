// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls, avoid_print

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sekkah_app/Homepage/services/locationServices.dart';

import '../../core/const.dart';
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
    dp(msg: "Camera animate");
    await googleMapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            bearing: 192.8334901395799, target: location, zoom: 14)));
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p) / 2 + cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<double> getRoutDistance( 
    GeoPoint endLocation, LatLng? currentPosition) async {
    double distance = 0.0;
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Const.apiKey,
      PointLatLng(currentPosition!.latitude, currentPosition.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }

//polulineCoordinates is the List of longitute and latidtude.
    double totalDistance = 0;
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    print('distance : $totalDistance');

    distance = totalDistance;
    return distance;
  }
}
