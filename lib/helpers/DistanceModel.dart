// ignore_for_file: non_constant_identifier_names, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sekkah_app/helpers/bus_station_model.dart';

class DistanceModel {
  final GeoPoint Location;
  final String Name;
  final int Number;
  final double Distance;
  const DistanceModel(
      {required this.Location,
      required this.Name,
      required this.Number,
      required this.Distance});

  factory DistanceModel.mapToBusModel(
      BusStationModel busModel, double distance) {
    return DistanceModel(
        Location: busModel.Location,
        Name: busModel.Name,
        Number: busModel.Number,
        Distance: distance);
  }
}
