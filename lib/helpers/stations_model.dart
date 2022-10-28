// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Stations {
  int ID;
  String Type;
  String Name;
  GeoPoint Location;
  bool Available;
  Stations({
    required this.ID,
    required this.Type,
    required this.Name,
    required this.Location,
    required this.Available,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ID': ID,
      'Type': Type,
      'Name': Name,
      'Location': Location,
      'Available': Available,
    };
  }

  factory Stations.fromMap(Map<String, dynamic> map) {
    return Stations(
      ID: map['ID'] as int,
      Type: map['Type'] as String,
      Name: map['Name'] as String,
      Location: map['Location'],
      Available: map['Available'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Stations.fromJson(String source) =>
      Stations.fromMap(json.decode(source) as Map<String, dynamic>);
}
