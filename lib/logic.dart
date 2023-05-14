// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, empty_statements

import 'package:geolocator/geolocator.dart';

import 'helpers/contains_model.dart';
import 'helpers/data.dart';
import 'helpers/route_model.dart';
import 'main.dart';

init({double? startlat,double? startlng,double? endLat,double? endLng,String? startname,String? endname}) async {
  List<String> nameList=[];
  ContainsModel? startingLine;
  ContainsModel? endLine;
  List<RouteModel> exproute=[];
  List<String>? intersection;
  searchname? start;
  searchname? end;
  distance? startdis;
  distance? enddis;
  bool? isAdd;
  start=searchname(name: startname,lat: startlat,lng: startlng);
  end=searchname(name: endname,lat: endLat,lng: endLng);
  await metroService.metroStation().then((v){
    startdis=distance(name: v.first.Name,dis:Geolocator.distanceBetween(start!.lat!,start.lng!, v.first.Location.latitude,v.first.Location.longitude));
    v.forEach((e) {
      print("*-*-*-*-*-*-* ${e.Name}");
      print("-*-*-*-*-*-*-*-*-*-*-*-* ${Geolocator.distanceBetween(start!.lat!,start!.lng!, e.Location.latitude,e.Location.longitude)} &&&  ${e.Name}");
      if(startdis!.dis!>Geolocator.distanceBetween(start!.lat!,start!.lng!, e.Location.latitude,e.Location.longitude)){
        startdis=distance(name: e.Name,dis:Geolocator.distanceBetween(start!.lat!,start!.lng!, e.Location.latitude,e.Location.longitude));
      }
    });
  });
  print(" ===+++++++++++++++++++ ${startdis!.name!}");
  await metroService.metroStation().then((v){
    enddis=distance(name: v.first.Name,dis:Geolocator.distanceBetween(end!.lat!,end!.lng!, v.first.Location.latitude,v.first.Location.longitude));
    v.forEach((e) {
      if(enddis!.dis!>Geolocator.distanceBetween(end!.lat!,end!.lng!, e.Location.latitude,e.Location.longitude)){
        enddis=distance(name: e.Name,dis:Geolocator.distanceBetween(end!.lat!,end!.lng!, e.Location.latitude,e.Location.longitude));
      }
    });
  });
  print(" -=-=-=- end ===+++++++++++++++++++ ${enddis!.name!}");
  await metroService.containsAssending().then((value){
    value.forEach((element) {
      if(element.Name==startdis!.name!){
        print("======================== ${element.Name} &&& ${element.Line_ID.id}");
        startingLine=element;
      }else if(element.Name==enddis!.name!){
        endLine=element;
      }
    });
  });
  print("--- line =-=-=-==-=-= ${startingLine!.Line_ID.id}");
  print("---END  line =-=-=-==-=-= ${endLine!.Line_ID.id}");
  if(endLine!.Line_ID.id==startingLine!.Line_ID.id){
    if(int.parse(startingLine!.Order)>int.parse(endLine!.Order)){
      print("end First *-*-*-*-*-*-*-/*/*/*//*/*/*/*/*/*/*/*/*/***/*//*/*");
      await  metroService.containsDescending().then((value){
        value.forEach((e) async {
          if(e.Line_ID.id==startingLine!.Line_ID.id){
            print("=========== ${e.Name} ===== ${e.Line_ID.id} &&& ${e.Order}");
            nameList.add(e.Name);

          }
        });
      });
      for (var element in nameList)  {
        await metroService.getMetroStation(Name: element).then((v){
          v.forEach((element) {
            print("+++++++++++++++++++++++++++++++ ${element.Name} &&& ${element.Location.latitude} &&& ${element.Location.longitude}");
            if(element.Name==startdis!.name! || element.Name==enddis!.name!){
              isAdd=true;
            };
            if(isAdd==true){
              exproute.add(RouteModel(type: 'metro',isShow: true,name: element.Name,lat: element.Location.latitude,lng: element.Location.longitude));
              if(element.Name==enddis!.name! ){
                isAdd=false;
                exproute.add(RouteModel(type: 'walk',isShow: true,name:end!.name!,lat:end!.lat!,lng:end!.lng!));
              }
            }
          });

        });
      }
    }else{
      await  metroService.containsAssending().then((value){
        value.forEach((e) async {
          if(e.Line_ID.id==startingLine!.Line_ID.id){
            print("=========== ${e.Name} ===== ${e.Line_ID.id} &&& ${e.Order}");
            nameList.add(e.Name);

          }
        });
      });
      for (var element in nameList)  {
        await metroService.getMetroStation(Name: element).then((v){
          v.forEach((element) {
            print("+++++++++++++++++++++++++++++++ ${element.Name} &&& ${element.Location.latitude} &&& ${element.Location.longitude}");
            if(element.Name==startdis!.name! || element.Name==enddis!.name!){
              isAdd=true;
            }
            if(isAdd==true){
              exproute.add(RouteModel(type: 'metro',isShow: true,name: element.Name,lat: element.Location.latitude,lng: element.Location.longitude));
              if(element.Name==enddis!.name! ){
                isAdd=false;
                exproute.add(RouteModel(type: 'walk',isShow: true,name:end!.name!,lat:end!.lat!,lng:end!.lng!));
              }
            }
          });

        });
      }
    }
  }
  else{
    print("NOT SAME LINE");
    await  metroService.containsAssending().then((value){
      value.forEach((e) async {
        if(e.Line_ID.id==startingLine!.Line_ID.id){
          print("=========== ${e.Name} ===== ${e.Line_ID.id} &&& ${e.Order}");
          nameList.add(e.Name);
        }
      });
    });
    nameList.forEach((element) async {
      await  metroService.containsAssending().then((value){
        value.forEach((e) async {
          if(e.Line_ID.id==endLine!.Line_ID.id){
            if(e.Name==element){
              print("--+++-+--++--+-----+-+-++-++--+-+-+-++-+-+-++-+++-+--+-+-++-+--+ ${e.Name}");
              intersection!.add(e.Name);
            }
          }
        });
      });
    });
  }
}