import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sekkah_app/core/const.dart';
import 'package:sekkah_app/helpers/bus_%20model.dart';
import 'package:sekkah_app/helpers/stations_model.dart';

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
  factory DistanceModel.mapToBusModel(BusModel busModel, double distance) {
    return DistanceModel(
        Location: busModel.Location,
        Name: busModel.Name,
        Number: busModel.Number,
        Distance: distance);
  }
  // factory DistanceModel.mapToMetroModel(Stations metroModel, double distance) {
  //   return DistanceModel(
  //       Location: metroModel.Location,
  //       Name:  metroModel.Name,
  //       Number:  metroModel.Number,
  //       Distance: distance);
  // }
}
