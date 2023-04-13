// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

class RouteModel{
  String? type;
  double? lat;
  double? lng;
  String? name;
  bool? isShow;
  bool? isChange;
  String? line;
  Color? lineColor;
  bool? OnTime;

  RouteModel({
    this.lng,
    this.lat,
    this.name,
    this.type,
    this.isShow,
    this.isChange,
    this.line,
    this.lineColor,
    this.OnTime});
}