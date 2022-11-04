// ignore_for_file: non_constant_identifier_names, avoid_print
<<<<<<< HEAD
=======

import 'dart:math';

>>>>>>> 17a56efaba688019ffc6bee15f0168d95481b862
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sekkah_app/helpers/DiatanceModel.dart';
import 'package:sekkah_app/helpers/bus_%20model.dart';

import '../Homepage/providers/locationProvier.dart';
import '../core/const.dart';
import 'stations_model.dart';

class StationsController extends GetxController {
  final provider = Get.put(LocationProvider());

  RxList<DistanceModel> BusStations = <DistanceModel>[].obs;
  RxList<DistanceModel> MetroStations = <DistanceModel>[].obs;

  var stations_loading = false.obs;

  get_bus_stations() async {
    stations_loading(true);
<<<<<<< HEAD
    var result = await FirebaseFirestore.instance
        .collection("Bus_Station")
        // .where("type", isEqualTo: "Bus")
        .get();
    print("here is result data ${result.docs.length}");
    BusStations.addAll(result.docs);
=======

    final position = provider.currentLatLang;
    var result =
        await FirebaseFirestore.instance.collection("Bus_Station").get();
    final data = result.docs.map((e) => BusModel.fromMap(e.data())).toList();
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

>>>>>>> 17a56efaba688019ffc6bee15f0168d95481b862
    stations_loading(false);
    update();
  }

  get_Metro_stations() async {
<<<<<<< HEAD
    stations_loading(true);
    update();
    var result = await FirebaseFirestore.instance
        .collection("Metro_Station")
        //   .where("Type", isEqualTo: "Metro")
        .get();
    print("here is result data ${result.docs.length}");
    MetroStations.addAll(result.docs);
    stations_loading(false);
    update();
=======
    //   stations_loading(true);

    //   final position = provider.currentLatLang;

    //   var result =
    //       await FirebaseFirestore.instance.collection("Metro_Station").get();
    //   printInfo(info: '$result');

    //   final data = result.docs.map((e) => Stations.fromMap(e.data())).toList();
    //   final tempList = <DistanceModel>[];
    //   for (var item in data) {
    //     final location = item.Location;
    //     await provider.getRoutDistance(location, position).then((distance) {
    //       tempList.add(DistanceModel.mapToMetroModel(item, distance));
    //     });
    //   }
    //   BusStations.addAll(tempList);
    //   BusStations.sort(
    //     (a, b) {
    //       return a.Distance.compareTo(b.Distance);
    //     },
    //   );

    //   print("here is result data ${result.docs.length}");

    //   stations_loading(false);
    //   update();
>>>>>>> 17a56efaba688019ffc6bee15f0168d95481b862
  }
}
