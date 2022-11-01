// ignore_for_file: prefer_final_fields

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sekkah_app/helpers/contains_model.dart';
import 'package:sekkah_app/helpers/line_model.dart';
import '../helpers/stations_model.dart';

class MapStationsController extends GetxController {
  Rx<Map<MarkerId, Marker>> _markers = Rx<Map<MarkerId, Marker>>({});
  Map<MarkerId, Marker> get markers => _markers.value;
  Map<MarkerId, Marker> emptyMarkers = {};
  Rx<List<Stations>> _allStations = Rx<List<Stations>>([]);
  List<Stations> get allStations => _allStations.value;
  Rx<List<LineModel>> _allLines = Rx<List<LineModel>>([]);
  List<LineModel> get allLines => _allLines.value;

  set setAllStations(List<Stations> value) => _allStations.value = value;
  Rx<Set<Polyline>> _polyline = Rx<Set<Polyline>>({});
  Set<Polyline> get polyline => _polyline.value;
  Rx<List<ContainsModel>> _allContains = Rx<List<ContainsModel>>([]);
  List<ContainsModel> get allContains => _allContains.value;

  List<Stations> route1Stations = [];
  List<Stations> route2Stations = [];
  List<Stations> route3Stations = [];
  List<Stations> route4Stations = [];
  List<Stations> route5Stations = [];
  List<Stations> route6Stations = [];

  Future<List<LineModel>> getAllLines() async {
    return await FirebaseFirestore.instance
        .collection('Lines')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        _allLines.value
            .add(LineModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return _allLines.value;
    });
  }

  Future<List<ContainsModel>> getAllContains() async {
    return await FirebaseFirestore.instance
        .collection('Contains')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        _allContains.value
            .add(ContainsModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return _allContains.value;
    });
  }

  Stream<List<Stations>> getAllStations() {
    return FirebaseFirestore.instance
        .collection('Stations')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Stations.fromMap(doc.data());
            }).toList());
  }

  void initMarker(Stations specify, String specifyId) async {
    var markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/images/80.png',
    );
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(specify.Location.latitude, specify.Location.longitude),
      infoWindow: InfoWindow(title: 'Metro Station', snippet: specify.Name),
      icon: markerIcon,
    );
    _markers.value[markerId] = marker;
  }

  void setPolyLineData() {
    //Store all contains models according to line number
    List<ContainsModel> line1 = [],
        line2 = [],
        line3 = [],
        line4 = [],
        line5 = [],
        line6 = [];
    //ALL lines references
    DocumentReference line1Ref =
        FirebaseFirestore.instance.collection('Lines').doc('Line_1');
    DocumentReference line2Ref =
        FirebaseFirestore.instance.collection('Lines').doc('Line_2');
    DocumentReference line3Ref =
        FirebaseFirestore.instance.collection('Lines').doc('Line_3');
    DocumentReference line4Ref =
        FirebaseFirestore.instance.collection('Lines').doc('Line_4');
    DocumentReference line5Ref =
        FirebaseFirestore.instance.collection('Lines').doc('Line_5');
    DocumentReference line6Ref = FirebaseFirestore.instance
        .collection('Lines')
        .doc('Line_6'); // /Lines/Line_6
    //Filtering according to order number and assigning to each line
    for (var element in allContains) {
      if (element.LineName == line1Ref) {
        if (!line1.any((e) => e.Order == element.Order)) {
          line1.add(element);
        }
      } else if (element.LineName == line2Ref) {
        if (!line2.any((e) => e.Order == element.Order)) {
          line2.add(element);
        }
      } else if (element.LineName == line3Ref) {
        if (!line3.any((e) => e.Order == element.Order)) {
          line3.add(element);
        }
      } else if (element.LineName == line4Ref) {
        if (!line4.any((e) => e.Order == element.Order)) {
          line4.add(element);
        }
      } else if (element.LineName == line5Ref) {
        if (!line5.any((e) => e.Order == element.Order)) {
          line5.add(element);
        }
      } else if (element.LineName == line6Ref) {
        if (!line6.any((e) => e.Order == element.Order)) {
          line6.add(element);
        }
      }
    }

    //Sorting according to order number
    line1.sort((a, b) => a.Order.compareTo(b.Order));
    line2.sort((a, b) => a.Order.compareTo(b.Order));
    line3.sort((a, b) => a.Order.compareTo(b.Order));
    line4.sort((a, b) => a.Order.compareTo(b.Order));
    line5.sort((a, b) => a.Order.compareTo(b.Order));
    line6.sort((a, b) => a.Order.compareTo(b.Order));
    //making sure there are no duplicates when we assing values to routes

    route1Stations.clear();
    route2Stations.clear();
    route3Stations.clear();
    route4Stations.clear();
    route5Stations.clear();
    route6Stations.clear();

    //assinging values to routes [to make polyline] on map
    for (var element in line1) {
      //in line all station 1 are saved but with this
      if (allStations
              .firstWhere((e) =>
                  e.ID.toString() == element.StationName.id.split("_").last)

              ///Stations/Stations_5
              .ID
              .toString() ==
          element.StationName.id.split("_").last) {
        route1Stations.add(allStations.firstWhere(
            (e) => e.ID.toString() == element.StationName.id.split("_").last));
      }
    }
    for (var element in line2) {
      if (allStations
              .firstWhere((e) =>
                  e.ID.toString() == element.StationName.id.split("_").last)
              .ID
              .toString() ==
          element.StationName.id.split("_").last) {
        route2Stations.add(allStations.firstWhere(
            (e) => e.ID.toString() == element.StationName.id.split("_").last));
      }
    }
    for (var element in line3) {
      if (allStations
              .firstWhere((e) =>
                  e.ID.toString() == element.StationName.id.split("_").last)
              .ID
              .toString() ==
          element.StationName.id.split("_").last) {
        route3Stations.add(allStations.firstWhere(
            (e) => e.ID.toString() == element.StationName.id.split("_").last));
      }
    }
    for (var element in line4) {
      if (allStations
              .firstWhere((e) =>
                  e.ID.toString() == element.StationName.id.split("_").last)
              .ID
              .toString() ==
          element.StationName.id.split("_").last) {
        route4Stations.add(allStations.firstWhere(
            (e) => e.ID.toString() == element.StationName.id.split("_").last));
      }
    }
    for (var element in line5) {
      if (allStations
              .firstWhere((e) =>
                  e.ID.toString() == element.StationName.id.split("_").last)
              .ID
              .toString() ==
          element.StationName.id.split("_").last) {
        route5Stations.add(allStations.firstWhere(
            (e) => e.ID.toString() == element.StationName.id.split("_").last));
      }
    }
    for (var element in line6) {
      if (allStations
              .firstWhere((e) =>
                  e.ID.toString() == element.StationName.id.split("_").last)
              .ID
              .toString() ==
          element.StationName.id.split("_").last) {
        route6Stations.add(allStations.firstWhere(
            (e) => e.ID.toString() == element.StationName.id.split("_").last));
      }
    }

    log(route2Stations.length.toString());
    log(line2.length.toString());

    for (var element in route2Stations) {
      log(element.Name);
      log(element.ID.toString());
    }

    //adding polylines to map
    _polyline.value.add(
      Polyline(
          polylineId: const PolylineId('1'),
          points:
              geoPointToLatLng(route1Stations.map((e) => e.Location).toList()),
          color: Colors.blue),
    );
    _polyline.value.add(
      Polyline(
          polylineId: const PolylineId('2'),
          points:
              geoPointToLatLng(route2Stations.map((e) => e.Location).toList()),
          color: Colors.red),
    );
    _polyline.value.add(
      Polyline(
          polylineId: const PolylineId('3'),
          points:
              geoPointToLatLng(route3Stations.map((e) => e.Location).toList()),
          color: Colors.orange),
    );
    _polyline.value.add(
      Polyline(
          polylineId: const PolylineId('4'),
          points:
              geoPointToLatLng(route4Stations.map((e) => e.Location).toList()),
          color: Colors.yellow),
    );
    _polyline.value.add(
      Polyline(
          polylineId: const PolylineId('5'),
          points:
              geoPointToLatLng(route5Stations.map((e) => e.Location).toList()),
          color: Colors.green),
    );
    _polyline.value.add(
      Polyline(
          polylineId: const PolylineId('6'),
          points:
              geoPointToLatLng(route6Stations.map((e) => e.Location).toList()),
          color: Colors.purple),
    );
  }

  //converting geoPoint to LatLng to use in Map
  List<LatLng> geoPointToLatLng(List<GeoPoint> geoPoints) {
    return geoPoints.map((e) => LatLng(e.latitude, e.longitude)).toList();
  }
}
