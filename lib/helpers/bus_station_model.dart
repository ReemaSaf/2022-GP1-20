// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, file_names, camel_case_types
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
<<<<<<< HEAD:lib/helpers/bus_station_model.dart

class BusStationModel {
  bool Available;
=======
class BusModel {
>>>>>>> 17a56efaba688019ffc6bee15f0168d95481b862:lib/helpers/bus_ model.dart
  GeoPoint Location;
  String Name;
  int Number;

  BusStationModel({
    required this.Available,
    required this.Location,
    required this.Name,
    required this.Number,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Available': Available,
      'Location': Location,
      'Name': Name,
      'Number': Number,
    };
  }

  factory BusStationModel.fromMap(Map<String, dynamic> map) {
    return BusStationModel(
      Available: map['Available'],
      Location: map['Location'],
      Name: map['Name'],
      Number: map['Number'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BusStationModel.fromJson(String source) =>
      BusStationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
