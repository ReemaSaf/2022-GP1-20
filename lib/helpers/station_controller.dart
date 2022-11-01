// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class StationsController extends GetxController {
  var BusStations = [].obs;
  var MetroStations = [].obs;
  var stations_loading = false.obs;

  get_bus_stations() async {
    stations_loading(true);
    var result = await FirebaseFirestore.instance
        .collection("Stations")
        .where("type", isEqualTo: "Bus")
        .get();
    print("here is result data ${result.docs.length}");
    BusStations.addAll(result.docs);
    stations_loading(false);
    update();
  }

  get_Metro_stations() async {
    stations_loading(true);
    update();
    var result = await FirebaseFirestore.instance
        .collection("Stations")
        .where("Type", isEqualTo: "Metro")
        .get();
    print("here is result data ${result.docs.length}");
    MetroStations.addAll(result.docs);
    stations_loading(false);
    update();
  }
}
