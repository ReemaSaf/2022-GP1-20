// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls, avoid_print, unnecessary_brace_in_string_interps

import 'package:geolocator/geolocator.dart';

import '../../helpers/bus_station_model.dart';
import '../../helpers/contains_model.dart';
import 'data.dart';
import '../../helpers/route_model.dart';
import '../../main.dart';
import 'intersectionStation.dart';
import 'addPoints.dart';
import 'intersection.dart';
import '../../helpers/data.dart';

Future<List<RouteModel>?> busRoute({searchname? start,searchname? end}) async {
  List<String> nameList=[];
  ContainsModel? startingLine;
  ContainsModel? endLine;
  List<RouteModel> exproute=[];
  List<String> intersection=[];
  IntersectionModel? intersectionLine;
  IntersectionModel? intersectionLine1;
  IntersectionModel? intersectionLine2;
  bool noIntersectionSameLine=true;
  List<String> intersectionLineName=[];
  distance? startdis;
  distance? enddis;
  busDistance? busdis;
  BusStationModel? busData;
  bool? isAdd;

  exproute.add(RouteModel(type: 'walk',isShow: true,name:start!.name!,lat: start.lat!,lng:start.lng!));
  await metroService.busStation().then((v){
    busdis=busDistance(name: v.first.Name,number: v.first.Number,dis:Geolocator.distanceBetween(start.lat!,start.lng!, v.first.Location.latitude,v.first.Location.longitude));
    v.forEach((e) {
     if(e.Available==true){
       if(busdis!.dis!>Geolocator.distanceBetween(start.lat!,start.lng!, e.Location.latitude,e.Location.longitude)){
         busdis=busDistance(name: e.Name,number: e.Number,dis:Geolocator.distanceBetween(start.lat!,start.lng!, e.Location.latitude,e.Location.longitude));
         print("============================== busssssssssssssssssssssssssssssssssss ${e.Name} &&& ${e.Number}");
       }
     }
    });
  });
  await metroService.getBusStation(Name: busdis!.name!).then((value){
    value.forEach((element) {
     if(element.Available==true){
       if(element.Number==busdis!.number!){
         busData=element;
         print("============================ thisi s date ${element.Name} && ${element.Name} && ${element.Location.latitude}");
       }
     }
    });
  });
  exproute.add(RouteModel(type: 'Bus',isShow: true,name:busData!.Name,lat:busData!.Location.latitude,lng:busData!.Location.longitude,OnTime:busData!.OnTime));
  await metroService.metroStation().then((v){
    startdis=distance(name: v.first.Name,dis:Geolocator.distanceBetween(busData!.Location.latitude,busData!.Location.longitude, v.first.Location.latitude,v.first.Location.longitude));
    v.forEach((e) {
      if(startdis!.dis!>Geolocator.distanceBetween(busData!.Location.latitude,busData!.Location.longitude, e.Location.latitude,e.Location.longitude)){
        startdis=distance(name: e.Name,dis:Geolocator.distanceBetween(busData!.Location.latitude,busData!.Location.longitude, e.Location.latitude,e.Location.longitude));
      }
    });
  });
  await metroService.metroStation().then((v){
    enddis=distance(name: v.first.Name,dis:Geolocator.distanceBetween(end!.lat!,end.lng!, v.first.Location.latitude,v.first.Location.longitude));
    v.forEach((e) {
      if(enddis!.dis!>Geolocator.distanceBetween(end.lat!,end.lng!, e.Location.latitude,e.Location.longitude)){
        enddis=distance(name: e.Name,dis:Geolocator.distanceBetween(end.lat!,end.lng!, e.Location.latitude,e.Location.longitude));
      }
    });
  });

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


  ///
  ///
  print("--- line =-=-=-==-=-= ${startingLine!.Line_ID.id}");
  print("---END  line =-=-=-==-=-= ${endLine!.Line_ID.id}");
  if(endLine!.Line_ID.id==startingLine!.Line_ID.id){
    await addPoints(startingLine:startingLine,endLine: endLine).then((value) {
      value!.forEach((element) {
        exproute.add(element);
      });
      exproute.add(RouteModel(type: 'walk',isShow: true,name:end!.name!,lat:end.lat!,lng:end.lng!));
    });
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
    await metroService.containsAssending().then((value){
      value.forEach((e) {
        if(e.Line_ID.id==endLine!.Line_ID.id){
          nameList.forEach((element) {
            if(e.Name==element){
              print("--+++-+--++--+-----+-+-++-++--+-+-+-++-+-+-++-+++-+--+-+-++-+--+ ${e.Name}");
              intersection.add(e.Name);
              intersectionLine=IntersectionModel(Name: e.Name,Line_ID:e.Line_ID,MStation_ID: e.MStation_ID,OrderE:e.Order);
              print("this is intersectionLine -=-=-=-= ${intersectionLine!.Name} === ${intersectionLine!.Line_ID!.id} ===");
              noIntersectionSameLine=false;
            }
          });
        }
      });
    });
    /// Intersection not in same line

    if(noIntersectionSameLine==true){
      print("no intersection in same line -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- ");
      for(var element in getLineList(list: startingLine!.Line_ID.id)){
        for(var e in getLineList(list: endLine!.Line_ID.id)){
          if(element==e){
            print('inter line is $e =============================');
            intersectionLineName.add(e);
            // intersectionLineName=e;
          }
        }
      }
      ///finding intersectrion point
      for (var element in intersectionLineName)  {
        print("********************************************************* ${element}");
        exproute=[];
        exproute.add(RouteModel(type: 'walk',isShow: true,name:start!.name!,lat:start!.lat!,lng:start!.lng!));
        await intersectionStation(startingLine:startingLine!.Line_ID.id,endingLine:element).then((value) async {
          intersectionLine1=value;
          print("============================================================================================ ${value!.Line_ID!.id}");
          print("=-=-=-=-==-=-=-===-_++_+_+_+_+_+_+__+_++_+_   ${value.Name}");
          await intersationAddPoints(startingLine:startingLine,i1:value).then((value) {
            value!.forEach((element) {
              print("==================================  ${element.name}");
              exproute.add(element);
            });
          });
        });
        await intersectionStation(startingLine:endLine!.Line_ID.id,endingLine:element).then((value) {
          print("============================================================================================ ${value!.Line_ID!.id}");
          intersectionLine2=value;
          print("=-=-=-=-==-=-=-===-_++_+_+_+_+_+_+__+_++_+_   ${value.Name}");
        });
        await intersationAddPoints1(i1: intersectionLine1,i2: intersectionLine2).then((value) {
          value!.forEach((element) {
            exproute.add(element);
          });
        });
        await intersationAddPoints2(i2: intersectionLine2,endLine: endLine).then((value) {
          value!.forEach((element) {
            exproute.add(element);
          });
        });
        exproute.add(RouteModel(type: 'walk',isShow: true,name:end!.name!,lat:end!.lat!,lng:end!.lng!));
      }
    }
    else{
      await metroService.containsAssending().then((value){
        value.forEach((e) {
          if(e.Name==intersectionLine!.Name && startingLine!.Line_ID.id==e.Line_ID.id){
            intersectionLine!.OrderS=e.Order;
          }
        });
      });
      print("_______________________________________________${intersectionLine!.Name} &&& ${intersectionLine!.OrderS} && ${intersectionLine!.OrderE}");
      if(int.parse(startingLine!.Order)>int.parse(intersectionLine!.OrderS!)){
        print("this is deccending");
        nameList=[];
        await  metroService.containsDescending().then((value){
          value.forEach((e) async {
            if(e.Line_ID.id==startingLine!.Line_ID.id){
              nameList.add(e.Name);
            }
          });
        });
        for (var e in nameList)  {
          print("this are the name of list ======================== ${e}");
          await metroService.getMetroStation(Name: e).then((v){
            v.forEach((element) {
              if(element.Name==startdis!.name!){
                isAdd=true;
              }
              if(element.Name==intersectionLine!.Name){
                isAdd=false;
              }
              if(isAdd==true){
                exproute.add(RouteModel(type: 'metro',isShow: true,name: element.Name,lat: element.Location.latitude,lng: element.Location.longitude));
              }
            });

          });
        }
      }
      else{
        print("this is accending");
        await  metroService.containsAssending().then((value){
          nameList=[];
          value.forEach((e) async {
            if(e.Line_ID.id==startingLine!.Line_ID.id){
              nameList.add(e.Name);
            }
          });
        });
        for (var element in nameList)  {
          await metroService.getMetroStation(Name: element).then((v){
            v.forEach((element) {
              if(element.Name==startdis!.name!){
                isAdd=true;
              }
              if(element.Name==intersectionLine!.Name){
                isAdd=false;
              }
              if(isAdd==true){
                exproute.add(RouteModel(type: 'metro',isShow: true,name: element.Name,lat: element.Location.latitude,lng: element.Location.longitude));
              }
            });

          });
        }
      }
      /// this is from intersection to end
      if(int.parse(endLine!.Order)<int.parse(intersectionLine!.OrderE!)){
        nameList=[];
        await  metroService.containsDescending().then((value){
          value.forEach((e) async {
            if(e.Line_ID.id==endLine!.Line_ID.id){
              nameList.add(e.Name);
            }
          });
        });
        for (var element in nameList)  {
          await metroService.getMetroStation(Name: element).then((v){
            v.forEach((element) {
              if(element.Name==intersectionLine!.Name){
                isAdd=true;
              }
              if(isAdd==true){
                exproute.add(RouteModel(type: 'metro',isShow: true,name: element.Name,lat: element.Location.latitude,lng: element.Location.longitude));
                if(element.Name==enddis!.name){
                  isAdd=false;
                  exproute.add(RouteModel(type: 'walk',isShow: true,name:end!.name!,lat:end!.lat!,lng:end!.lng!));
                }
              }
            });

          });
        }
      }
      else{
        print("end line ${endLine!.Name} ${endLine!.Order}");
        await  metroService.containsAssending().then((value){
          nameList=[];
          value.forEach((e) async {
            if(e.Line_ID.id==endLine!.Line_ID.id){
              print("=========== ${e.Name} ===== ${e.Line_ID.id} &&& ${e.Order}");
              nameList.add(e.Name);
            }
          });
        });
        for (var element in nameList)  {
          await metroService.getMetroStation(Name: element).then((v){
            v.forEach((element) {
              print("+++++++++++++++++++++++++++++++ ${element.Name} &&& ${element.Location.latitude} &&& ${element.Location.longitude}");
              if(element.Name==enddis!.name!){
                isAdd=true;
              }
              if(isAdd==true){
                exproute.add(RouteModel(type: 'metro',isShow: true,name: element.Name,lat: element.Location.latitude,lng: element.Location.longitude));
                if(element.Name==intersectionLine!.Name ){
                  isAdd=false;
                  exproute.add(RouteModel(type: 'walk',isShow: true,name:end!.name!,lat:end!.lat!,lng:end!.lng!));
                }
              }
            });

          });
        }
      }
    }
  }
  return exproute;
}