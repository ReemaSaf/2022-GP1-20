// ignore_for_file: non_constant_identifier_names, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/helpers/DistanceModel.dart';
import 'package:sekkah_app/helpers/bus_station_model.dart';
import 'package:sekkah_app/helpers/metro_station_model.dart';
import '../Homepage/providers/locationProvider.dart';

class StationsController extends GetxController {
  final provider = Get.put(LocationProvider());

  RxList<DistanceModel> BusStations = <DistanceModel>[].obs;
  RxList<DistanceModel> MetroStations = <DistanceModel>[].obs;

  var stations_loading = false.obs;
  var mstations_loading = false.obs;

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
      await provider.distanceBetween(location, position).then((distance) {
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
    mstations_loading(true);
    final position = provider.currentLatLang;
    var result =
        await FirebaseFirestore.instance.collection("Metro_Station").get();
    printInfo(info: '$result');

    final data = result.docs
        .map((e) => MetroStationModel.fromMap(e.data(), e.id))
        .toList();
    final tempList = <DistanceModel>[];
    for (var item in data) {
      final location = item.Location;
      await provider.distanceBetween(location, position).then((distance) {
        tempList.add(DistanceModel.mapToMetroModel(item, distance));
      });
    }
    MetroStations.addAll(tempList);
    MetroStations.sort(
      (a, b) {
        return a.Distance.compareTo(b.Distance);
      },
    );

    print("here is result data ${result.docs.length}");
    mstations_loading(false);
    update();
  }
}
