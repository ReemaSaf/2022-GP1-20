// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContainsModel {
  DocumentReference Line_ID;
  DocumentReference MStation_ID;
  String Name;
  String Order;

  ContainsModel({
    required this.Line_ID,
    required this.MStation_ID,
    required this.Name,
    required this.Order,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Line_ID': Line_ID,
      'MStation_ID': MStation_ID,
      'Name': Name,
      'Order': Order,
    };
  }

  factory ContainsModel.fromMap(Map<String, dynamic> map) {
    return ContainsModel(
      Line_ID: map['Line_ID'],
      MStation_ID: map['MStation_ID'],
      Name: map['Name'],
      Order: map['Order'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ContainsModel.fromJson(String source) =>
      ContainsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
