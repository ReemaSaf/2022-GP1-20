// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class IntersectionModel{
  DocumentReference? Line_ID;
  DocumentReference? MStation_ID;
  String? Name;
  String? OrderS;
  String? OrderE;

  IntersectionModel({
    this.Line_ID,
    this.MStation_ID,
    this.Name,
    this.OrderS,
    this.OrderE,
  });
}