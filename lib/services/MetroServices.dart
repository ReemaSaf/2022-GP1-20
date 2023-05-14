// ignore_for_file: non_constant_identifier_names, file_names

import 'package:cloud_firestore/cloud_firestore.dart';

import '../helpers/bus_station_model.dart';
import '../helpers/contains_model.dart';
import '../helpers/metro_station_model.dart';

class MetroService{
  Future<List<MetroStationModel>> metroStation() async {
    return FirebaseFirestore.instance
        .collection('Metro_Station')
        .get().then((value) => value.docs.map((e) => MetroStationModel.fromMap(e.data(),e.id)).toList());
  }
  Future<List<MetroStationModel>> getMetroStation({String? Name}) async {
    return FirebaseFirestore.instance
        .collection('Metro_Station').where("Name",isEqualTo: Name)
        .get().then((value) => value.docs.map((e) => MetroStationModel.fromMap(e.data(),e.id)).toList());
  }

  Future<List<ContainsModel>> containsAssending() async {
    return FirebaseFirestore.instance
        .collection('Contains').orderBy("Order")
        .get().then((value) => value.docs.map((e) => ContainsModel.fromMap(e.data())).toList());
  }

  Future<List<ContainsModel>> containsDescending() async {
    return FirebaseFirestore.instance
        .collection('Contains').orderBy("Order",descending: true)
        .get().then((value) => value.docs.map((e) => ContainsModel.fromMap(e.data())).toList());
  }


  Future<List<ContainsModel>> getLine({String? station}) async {
    return FirebaseFirestore.instance
        .collection('Contains').where('Name'==station)
        .get().then((value) => value.docs.map((e) => ContainsModel.fromMap(e.data())).toList());
  }

  Future<List<BusStationModel>> busStation() async {
    return FirebaseFirestore.instance
        .collection('Bus_Station')
        .get().then((value) => value.docs.map((e) => BusStationModel.fromMap(e.data())).toList());
  }
  
  Future<List<BusStationModel>> getBusStation({String? Name}) async {
    return FirebaseFirestore.instance
        .collection('Bus_Station').where("Name",isEqualTo: Name)
        .get().then((value) => value.docs.map((e) => BusStationModel.fromMap(e.data())).toList());

  }
}