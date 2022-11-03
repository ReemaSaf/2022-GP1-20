// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, file_names
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class BusModel {
  GeoPoint Location;
  String Name;
  int Number;
  BusModel({
    required this.Location,
    required this.Name,
    required this.Number,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Location': Location,
      'Name': Name,
      'Number': Number,
    };
  }

  factory BusModel.fromMap(Map<String, dynamic> map) {
    return BusModel(
      Location: map['Location'],
      Name: map['Name'] as String,
      Number: map['Number'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory BusModel.fromJson(String source) =>
      BusModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
