// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, file_names, camel_case_types
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusStationModel {
  bool Available;
  GeoPoint Location;
  String Name;
  int Number;
  bool? OnTime;

  BusStationModel({
    required this.Available,
    required this.Location,
    required this.Name,
    required this.Number,
    required this.OnTime
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Available': Available,
      'Location': Location,
      'Name': Name,
      'Number': Number,
      'OnTime': OnTime,
    };
  }

  factory BusStationModel.fromMap(Map<String, dynamic> map) {
    return BusStationModel(
      Available: map['Available'],
      Location: map['Location'],
      Name: map['Name'],
      Number: map['Number'],
      OnTime: map['OnTime'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BusStationModel.fromJson(String source) =>
      BusStationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
