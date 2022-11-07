// ignore_for_file: prefer_final_fields

//import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sekkah_app/helpers/contains_model.dart';
import 'package:sekkah_app/helpers/line_model.dart';
import '../helpers/bus_station_model.dart';
import '../helpers/metro_station_model.dart';

class MapStationsController extends GetxController {
  Rx<Map<MarkerId, Marker>> _allMarkers = Rx<Map<MarkerId, Marker>>({});
  Map<MarkerId, Marker> get allMarkers => _allMarkers.value;
  Rx<Map<MarkerId, Marker>> _stationMarkers = Rx<Map<MarkerId, Marker>>({});
  Map<MarkerId, Marker> get stationMarkers => _stationMarkers.value;
  Rx<Map<MarkerId, Marker>> _busMarkers = Rx<Map<MarkerId, Marker>>({});
  Map<MarkerId, Marker> get busMarkers => _busMarkers.value;
  Map<MarkerId, Marker> emptyMarkers = {};
  Rx<List<MetroStationModel>> _allStations = Rx<List<MetroStationModel>>([]);
  List<MetroStationModel> get allStations => _allStations.value;
  Rx<List<BusStationModel>> _allBuses = Rx<List<BusStationModel>>([]);
  List<BusStationModel> get allBuses => _allBuses.value;
  Rx<List<LineModel>> _allLines = Rx<List<LineModel>>([]);
  List<LineModel> get allLines => _allLines.value;
  set setAllBuses(List<BusStationModel> value) => _allBuses.value = value;
  set setAllStations(List<MetroStationModel> value) =>
      _allStations.value = value;
  Rx<Set<Polyline>> _polyline = Rx<Set<Polyline>>({}); // test it
  Set<Polyline> get polyline => _polyline.value;
  Rx<List<ContainsModel>> _allContains = Rx<List<ContainsModel>>([]);
  List<ContainsModel> get allContains => _allContains.value;

  List<MetroStationModel> route1Stations = [];
  List<MetroStationModel> route2Stations = [];
  List<MetroStationModel> route3Stations = [];
  List<MetroStationModel> route4Stations = [];
  List<MetroStationModel> route5Stations = [];
  List<MetroStationModel> route6Stations = [];

  Future<List<LineModel>> getAllLines() async {
    return await FirebaseFirestore.instance
        .collection('Line')
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

  Stream<List<MetroStationModel>> getAllStations() {
    return FirebaseFirestore.instance
        .collection('Metro_Station')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return MetroStationModel.fromMap(doc.data(), doc.id);
            }).toList());
  }

  Stream<List<BusStationModel>> getAllBuses() {
    return FirebaseFirestore.instance
        .collection("Bus_Station")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return BusStationModel.fromMap(doc.data());
            }).toList());
  }

  void initStationMarkers(MetroStationModel specify, String specifyId) async {
    var markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/images/metro.png',
    );
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(specify.Location.latitude, specify.Location.longitude),
      infoWindow: InfoWindow(title: 'Metro Station', snippet: specify.Name),
      icon: markerIcon,
    );
    _stationMarkers.value[markerId] = marker;
  }

  void initBusMarkers(BusStationModel specify, String specifyId) async {
    var markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/images/bus.png',
    );
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(specify.Location.latitude, specify.Location.longitude),
      infoWindow: InfoWindow(
          title: 'Bus Station', snippet: "${specify.Name} ${specify.Number}"),
      icon: markerIcon,
    );
    _busMarkers.value[markerId] = marker;
  }

  void setAllMarkers() {
    _allMarkers.value.clear();
    _allMarkers.value.addAll(stationMarkers);
    _allMarkers.value.addAll(busMarkers);
  }

  void setPolyLineData() {
    //Store all contains models according to the line number
    List<ContainsModel> line1 = [],
        line2 = [],
        line3 = [],
        line4 = [],
        line5 = [],
        line6 = [];

    //All lines references
    DocumentReference line1Ref =
        FirebaseFirestore.instance.collection('Line').doc('Line_1');
    DocumentReference line2Ref =
        FirebaseFirestore.instance.collection('Line').doc('Line_2');
    DocumentReference line3Ref =
        FirebaseFirestore.instance.collection('Line').doc('Line_3');
    DocumentReference line4Ref =
        FirebaseFirestore.instance.collection('Line').doc('Line_4');
    DocumentReference line5Ref =
        FirebaseFirestore.instance.collection('Line').doc('Line_5');
    DocumentReference line6Ref =
        FirebaseFirestore.instance.collection('Line').doc('Line_6');

    //Filtering according to the order number and assigning it to each line
    for (var element in allContains) {
      if (element.Line_ID == line1Ref) {
        if (!line1.any((e) => e.Order == element.Order)) {
          line1.add(element);
        }
      } else if (element.Line_ID == line2Ref) {
        if (!line2.any((e) => e.Order == element.Order)) {
          line2.add(element);
        }
      } else if (element.Line_ID == line3Ref) {
        if (!line3.any((e) => e.Order == element.Order)) {
          line3.add(element);
        }
      } else if (element.Line_ID == line4Ref) {
        if (!line4.any((e) => e.Order == element.Order)) {
          line4.add(element);
        }
      } else if (element.Line_ID == line5Ref) {
        if (!line5.any((e) => e.Order == element.Order)) {
          line5.add(element);
        }
      } else if (element.Line_ID == line6Ref) {
        if (!line6.any((e) => e.Order == element.Order)) {
          line6.add(element);
        }
      }
    }

    //Sorting according to the order number
    line1.sort((a, b) => a.Order.compareTo(b.Order));
    line2.sort((a, b) => a.Order.compareTo(b.Order));
    line3.sort((a, b) => a.Order.compareTo(b.Order));
    line4.sort((a, b) => a.Order.compareTo(b.Order));
    line5.sort((a, b) => a.Order.compareTo(b.Order));
    line6.sort((a, b) => a.Order.compareTo(b.Order));
    //making sure there are no duplicates when we assign values to lines

    route1Stations.clear();
    route2Stations.clear();
    route3Stations.clear();
    route4Stations.clear();
    route5Stations.clear();
    route6Stations.clear();

    //assinging values to lines [to make polyline] on map
    for (var element in line1) {
      // all stations in line1 are saved with this
      if (allStations
              .firstWhere((e) => e.id.toString() == element.MStation_ID.id)
              .id
              .toString() ==
          element.MStation_ID.id) {
        route1Stations.add(allStations
            .firstWhere((e) => e.id.toString() == element.MStation_ID.id));
      }
    }
    for (var element in line2) {
      if (allStations
              .firstWhere((e) => e.id.toString() == element.MStation_ID.id)
              .id
              .toString() ==
          element.MStation_ID.id) {
        route2Stations.add(allStations
            .firstWhere((e) => e.id.toString() == element.MStation_ID.id));
      }
    }
    for (var element in line3) {
      if (allStations
              .firstWhere((e) => e.id.toString() == element.MStation_ID.id)
              .id
              .toString() ==
          element.MStation_ID.id) {
        route3Stations.add(allStations
            .firstWhere((e) => e.id.toString() == element.MStation_ID.id));
      }
    }
    for (var element in line4) {
      if (allStations
              .firstWhere((e) => e.id.toString() == element.MStation_ID.id)
              .id
              .toString() ==
          element.MStation_ID.id) {
        route4Stations.add(allStations
            .firstWhere((e) => e.id.toString() == element.MStation_ID.id));
      }
    }
    for (var element in line5) {
      if (allStations
              .firstWhere((e) => e.id.toString() == element.MStation_ID.id)
              .id
              .toString() ==
          element.MStation_ID.id) {
        route5Stations.add(allStations
            .firstWhere((e) => e.id.toString() == element.MStation_ID.id));
      }
    }
    for (var element in line6) {
      if (allStations
              .firstWhere((e) => e.id.toString() == element.MStation_ID.id)
              .id
              .toString() ==
          element.MStation_ID.id) {
        route6Stations.add(allStations
            .firstWhere((e) => e.id.toString() == element.MStation_ID.id));
      }
    }

    _polyline.value.clear();

    //adding polylines to map
    _polyline.value.add(
      Polyline(
          polylineId: const PolylineId('1'),
          width: 4,
          points:
              geoPointToLatLng(route1Stations.map((e) => e.Location).toList()),
          color: Colors.blue),
    );
    _polyline.value.add(
      Polyline(
          width: 4,
          polylineId: const PolylineId('2'),
          points:
              geoPointToLatLng(route2Stations.map((e) => e.Location).toList()),
          color: Colors.red),
    );
    _polyline.value.add(
      Polyline(
          width: 4,
          polylineId: const PolylineId('3'),
          points:
              geoPointToLatLng(route3Stations.map((e) => e.Location).toList()),
          color: Colors.orange),
    );
    _polyline.value.add(
      Polyline(
          width: 5,
          polylineId: const PolylineId('4'),
          points:
              geoPointToLatLng(route4Stations.map((e) => e.Location).toList()),
          color: Colors.yellow),
    );
    _polyline.value.add(
      Polyline(
          width: 4,
          polylineId: const PolylineId('5'),
          points:
              geoPointToLatLng(route5Stations.map((e) => e.Location).toList()),
          color: Colors.green),
    );
    _polyline.value.add(
      Polyline(
          width: 2,
          polylineId: const PolylineId('6'),
          points:
              geoPointToLatLng(route6Stations.map((e) => e.Location).toList()),
          color: Colors.purple),
    );
  }

  //converting geoPoint to LatLng to use it in the Map
  List<LatLng> geoPointToLatLng(List<GeoPoint> geoPoints) {
    return geoPoints.map((e) => LatLng(e.latitude, e.longitude)).toList();
  }
}
