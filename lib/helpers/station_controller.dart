// ignore_for_file: non_constant_identifier_names, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:sekkah_app/helpers/DistanceModel.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../Homepage/providers/locationProvier.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'bus_station_model.dart';

import '../core/const.dart';
import 'metro_station_model.dart';

class StationsController extends GetxController {
  final provider = Get.put(LocationProvider());

  RxList<DistanceModel> BusStations = <DistanceModel>[].obs;
  RxList<DistanceModel> MetroStations = <DistanceModel>[].obs;

  var stations_loading = false.obs;

  get_bus_stations() async {
    stations_loading(true);

    final position = provider.currentLatLang;
    var result =
        await FirebaseFirestore.instance.collection("Bus_Station").get();
    final data =
        result.docs.map((e) => BusStationModel.fromMap(e.data())).toList();
    final tempList = <DistanceModel>[];
    for (var item in data) {
      final location = item.Location;
      await provider.getRoutDistance(location, position).then((distance) {
        tempList.add(DistanceModel.mapToBusModel(item, distance));
      });
    }

    BusStations.addAll(tempList);
    BusStations.sort(
      (a, b) {
        return a.Distance.compareTo(b.Distance);
      },
    );
    print("here is result data ${BusStations.length}");

    stations_loading(false);
    update();
  }

  get_Metro_stations() async {
       stations_loading(true);

       final position = provider.currentLatLang;

       var result =
           await FirebaseFirestore.instance.collection("Metro_Station").get();
       printInfo(info: '$result');

       final data = result.docs.map((e) => MetroStationModel.fromMap(e.data())).toList();
       final tempList = <DistanceModel>[];
       for (var item in data) {
         final location = item.Location;
         await provider.getRoutDistance(location, position).then((distance) {
           tempList.add(DistanceModel.mapToMetroModel(item, distance));
         });
       }
       BusStations.addAll(tempList);
       BusStations.sort(
         (a, b) {
           return a.Distance.compareTo(b.Distance);
         },
       );

       print("here is result data ${result.docs.length}");

       stations_loading(false);
       update();
  }
}
