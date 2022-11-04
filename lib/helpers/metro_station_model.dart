// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, camel_case_types, file_names
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class MetroStationModel {
  bool Available;
  GeoPoint Location;
  String Name;
  String? id;
  MetroStationModel(
      {required this.Available,
      required this.Location,
      required this.Name,
      this.id});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Available': Available,
      'Location': Location,
      'Name': Name,
    };
  }

  factory MetroStationModel.fromMap(Map<String, dynamic> map, String id) {
    return MetroStationModel(
        Available: map['Available'],
        Location: map['Location'],
        Name: map['Name'],
        id: id);
  }

  String toJson() => json.encode(toMap());
}
