// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ContainsModel {
  String Name;
  String Order;
  DocumentReference LineName;
  DocumentReference StationName;
  ContainsModel({
    required this.Name,
    required this.Order,
    required this.LineName,
    required this.StationName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Name': Name,
      'Order': Order,
      'Line Name': LineName,
      'Station Name': StationName,
    };
  }

  factory ContainsModel.fromMap(Map<String, dynamic> map) {
    return ContainsModel(
      Name: map['Name'],
      Order: map['Order'],
      LineName: map['Line Name'],
      StationName: map['Station Name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ContainsModel.fromJson(String source) =>
      ContainsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
