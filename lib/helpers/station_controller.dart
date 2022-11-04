// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sekkah_app/helpers/bus_%20model.dart';

import '../Homepage/providers/locationProvier.dart';
import '../core/const.dart';
import 'stations_model.dart';

class StationsController extends GetxController {
  final provider = Get.put(LocationProvider());

  RxList<BusModel> BusStations = <BusModel>[].obs;

  var MetroStations = [].obs;
  var stations_loading = false.obs;
  var MetrodistanceList = <double>[].obs;
  var BusdistanceList = <double>[].obs;

  get_bus_stations() async {
    stations_loading(true);

    final position = provider.currentLatLang;
    var result =
        await FirebaseFirestore.instance.collection("Bus_Station").get();
    final data = result.docs.map((e) => BusModel.fromMap(e.data())).toList();

    for (int i = 0; i < data.length; i++) {
      final location = data[i].Location;
      final distance = await provider.getRoutDistance(location, position);
      BusdistanceList.add(distance);
      print(" ${BusdistanceList.length}");
    }
    BusdistanceList.sort();
    print("here is result data ${result.docs.length}");
    BusStations.addAll(data);
    stations_loading(false);
    update();
  }

  get_Metro_stations() async {
    stations_loading(true);

    final position = provider.currentLatLang;

    var result =
        await FirebaseFirestore.instance.collection("Metro_Station").get();
    printInfo(info: '$result');

    final data = result.docs.map((e) => Stations.fromMap(e.data())).toList();
    for (int i = 0; i < data.length; i++) {
      final location = data[i].Location;
      final distance = await provider.getRoutDistance(location, position);
      MetrodistanceList.add(distance);
    }
    MetrodistanceList.sort();
    print("here is result data ${result.docs.length}");
    MetroStations.addAll(result.docs);

    stations_loading(false);
    update();
  }
}
