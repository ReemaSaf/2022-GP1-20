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
  bool? onTime;

  RouteModel({this.lng,this.lat,this.name,this.type,this.isShow,this.isChange,this.line,this.lineColor,this.onTime});
}