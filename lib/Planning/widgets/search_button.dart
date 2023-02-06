// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../routeHelpers/IntersectionStation.dart';
import '../routeHelpers/addPoints.dart';
import '../routeHelpers/busStations.dart';
import '../routeHelpers/data.dart';
import '../routeHelpers/intersection.dart';
import '../../data/constants.dart';
import '../../data/typography.dart';
import '../../helpers/contains_model.dart';
import '../../helpers/data.dart';
import '../../helpers/distance_model.dart';
import '../../helpers/route_model.dart';
import '../../main.dart';
import '../plan_route_screen.dart';

class SearchRoutesButton extends StatefulWidget {
  const SearchRoutesButton({
    Key? key,
    required this.originLatLong,
    required this.destinationLatLang,
    required this.originAddress,
    required this.destinationAddress,
  }) : super(key: key);

  final List originLatLong;
  final List destinationLatLang;
  final String originAddress;
  final String destinationAddress;

  @override
  State<SearchRoutesButton> createState() => _SearchRoutesButtonState();
}

class _SearchRoutesButtonState extends State<SearchRoutesButton> {
  // List<distancemodel> distance=[];
  distancemodel? shortdistance;
  List<List<RouteModel>> routeListList=[];
  List<RouteModel> exproute=[];
  List<RouteModel> exproute1=[];
  List<RouteModel> exproute2=[];
  List<String> nameList=[];
  ContainsModel? startingLine;
  ContainsModel? endLine;
  List<String> intersection=[];
  IntersectionModel? intersectionLine;
  IntersectionModel? intersectionLine1;
  IntersectionModel? intersectionLine2;
  bool noIntersectionSameLine=true;
  List<String> intersectionLineName=[];
  searchname? start;
  searchname? end;
  distance? startdis;
  distance? enddis;
  bool? isAdd;
  bool isShow=true;

  @override
  void initState() {
    // TODO: implement initState
    // init();
  }
  @override
  Widget build(BuildContext context) {
    return isShow==false?Center(child: CircularProgressIndicator()):Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: SizedBox(
        height: Get.height * 0.05,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: CustomColor.kprimaryblue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24))),
          onPressed: () async {
            {
              exproute=[];
              if(widget.originAddress!=null&&widget.destinationAddress!=null){
                setState(() {
                  isShow=false;
                });
              }
              start=searchname(name: widget.originAddress,lat: widget.originLatLong[0],lng:  widget.originLatLong[1]);
              end=searchname(name: widget.destinationAddress,lat: widget.destinationLatLang[0],lng: widget.destinationLatLang[1]);
              ///Get Nearest Sation
              await metroService.metroStation().then((v){
                startdis=distance(name: v.first.Name,dis:Geolocator.distanceBetween(start!.lat!,start!.lng!, v.first.Location.latitude,v.first.Location.longitude));
                v.forEach((e) {
                  if(startdis!.dis!>Geolocator.distanceBetween(start!.lat!,start!.lng!, e.Location.latitude,e.Location.longitude)){
                    startdis=distance(name: e.Name,dis:Geolocator.distanceBetween(start!.lat!,start!.lng!, e.Location.latitude,e.Location.longitude));
                  }
                });
              });
              print(" ===+++++++++++++++++++ ${startdis!.name!}");
              ///End Metro
              await metroService.metroStation().then((v){
                enddis=distance(name: v.first.Name,dis:Geolocator.distanceBetween(end!.lat!,end!.lng!, v.first.Location.latitude,v.first.Location.longitude));
                v.forEach((e) {
                  if(enddis!.dis!>Geolocator.distanceBetween(end!.lat!,end!.lng!, e.Location.latitude,e.Location.longitude)){
                    enddis=distance(name: e.Name,dis:Geolocator.distanceBetween(end!.lat!,end!.lng!, e.Location.latitude,e.Location.longitude));
                  }
                });
              });
              print(" -=-=-=- end ===+++++++++++++++++++ ${enddis!.name!}");
              ///Get Contains
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
                exproute.add(RouteModel(type: 'walk',isShow: true,name:start!.name!,lat:start!.lat!,lng:start!.lng!));
                await addPoints(startingLine:startingLine,endLine: endLine).then((value) {
                  value!.forEach((element) {
                    exproute.add(element);
                  });
                  exproute.add(RouteModel(type: 'walk',isShow: true,name:end!.name!,lat:end!.lat!,lng:end!.lng!));
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
                ///check intersection between two line
                await metroService.containsAssending().then((value){
                  value.forEach((e) {
                    if(e.Line_ID.id==endLine!.Line_ID.id){
                      nameList.forEach((element) {
                        if(e.Name==element){
                          print("--+++-+--++--+-----+-+-++-++--+-+-+-++-+-+-++-+++-+--+-+-++-+--+ ${e.Name}");
                          intersection.add(e.Name);
                          intersectionLine=IntersectionModel(Name: e.Name,Line_ID:e.Line_ID,MStation_ID: e.MStation_ID,OrderE:e.Order);
                          print("this is intersectionLine -=-=-=-= ${intersectionLine!.Name} === ${intersectionLine!.Line_ID!.id} ===");
                          setState(() {
                            noIntersectionSameLine=false;
                          });
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
                    exproute2=[];
                    exproute2.add(RouteModel(type: 'walk',isShow: true,name:start!.name!,lat:start!.lat!,lng:start!.lng!));
                    await intersectionStation(startingLine:startingLine!.Line_ID.id,endingLine:element).then((value) async {
                      intersectionLine1=value;
                      print("============================================================================================ ${value!.Line_ID!.id}");
                      print("=-=-=-=-==-=-=-===-_++_+_+_+_+_+_+__+_++_+_   ${value.Name}");
                      await intersationAddPoints(startingLine:startingLine,i1:value).then((value) {
                        value!.forEach((element) {
                          print("==================================  ${element.name}");
                          exproute2.add(element);
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
                        exproute2.add(element);
                      });
                    });
                    await intersationAddPoints2(i2: intersectionLine2,endLine: endLine).then((value) {
                      value!.forEach((element) {
                        exproute2.add(element);
                      });
                    });
                    exproute2.add(RouteModel(type: 'walk',isShow: true,name:end!.name!,lat:end!.lat!,lng:end!.lng!));
                    routeListList.add(exproute2);
                  }
                }
                else{
                  exproute.add(RouteModel(type: 'walk',isShow: true,name:start!.name!,lat:start!.lat!,lng:start!.lng!));
                  await metroService.containsAssending().then((value){
                    value.forEach((e) {
                      if(e.Name==intersectionLine!.Name && startingLine!.Line_ID.id==e.Line_ID.id){
                        intersectionLine!.OrderS=e.Order;
                      }
                    });
                  });
                  print("_______________________________________________${intersectionLine!.Name} &&& ${intersectionLine!.OrderS} && ${intersectionLine!.OrderE}");
                  if(int.parse(startingLine!.Order)>int.parse(intersectionLine!.OrderS!)){
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
                          setState(() {
                            if(element.Name==startdis!.name! || element.Name==intersectionLine!.Name){
                              isAdd=true;
                            }
                          });
                          if(isAdd==true){
                            exproute.add(RouteModel(type: 'metro',isShow: true,name: element.Name,lat: element.Location.latitude,lng: element.Location.longitude));
                            setState(() {
                              if(element.Name==intersectionLine!.Name ){
                                isAdd=false;
                                exproute.add(RouteModel(type: 'walk',isShow: true,name:end!.name!,lat:end!.lat!,lng:end!.lng!));
                              }
                            });
                          }
                        });

                      });
                    }
                  }else{
                    print("end First *-*-*-*-*-*-*-/*/*/*//*/*/*/*/*/*/*/*/*/***/*//*/*");
                    print("============================================================= step 2");
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
                          setState(() {
                            if(element.Name==startdis!.name! || element.Name==intersectionLine!.Name){
                              isAdd=true;
                            }
                          });
                          if(isAdd==true){
                            exproute.add(RouteModel(type: 'metro',isShow: true,name: element.Name,lat: element.Location.latitude,lng: element.Location.longitude));
                            setState(() {
                              if(element.Name==intersectionLine!.Name ){
                                isAdd=false;
                                // exproute.add(RouteModel(type: 'walk',isShow: true,name:end!.name!,lat:end!.lat!,lng:end!.lng!));
                              }
                            });
                          }
                        });

                      });
                    }
                  }
                  /// this is from intersection to end
                  if(int.parse(endLine!.Order)>int.parse(intersectionLine!.OrderE!)){
                    print("end First *-*-*-*-*-*-*-/*/*/*//*/*/*/*/*/*/*/*/*/***/*//*/*");
                    print("============================================================= step 3");
                    nameList=[];
                    await  metroService.containsDescending().then((value){
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
                          setState(() {
                            if(element.Name==enddis!.name! || element.Name==intersectionLine!.Name){
                              isAdd=true;
                            }
                          });
                          if(isAdd==true){
                            exproute.add(RouteModel(type: 'metro',isShow: true,name: element.Name,lat: element.Location.latitude,lng: element.Location.longitude));
                            setState(() {
                              if(element.Name==intersectionLine!.Name ){
                                isAdd=false;
                                exproute.add(RouteModel(type: 'walk',isShow: true,name:end!.name!,lat:end!.lat!,lng:end!.lng!));
                              }
                            });
                          }
                        });

                      });
                    }
                  }else{
                    print("end First *-*-*-*-*-*-*-/*/*/*//*/*/*/*/*/*/*/*/*/***/*//*/*");
                    print("============================================================= step 3");
                    await  metroService.containsAssending().then((value){
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
                          setState(() {
                            if(element.Name==enddis!.name! || element.Name==intersectionLine!.Name){
                              isAdd=true;
                            }
                          });
                          if(isAdd==true){
                            exproute.add(RouteModel(type: 'metro',isShow: true,name: element.Name,lat: element.Location.latitude,lng: element.Location.longitude));
                            setState(() {
                              if(element.Name==intersectionLine!.Name ){
                                isAdd=false;
                                exproute.add(RouteModel(type: 'walk',isShow: true,name:end!.name!,lat:end!.lat!,lng:end!.lng!));
                              }
                            });
                          }
                        });

                      });
                    }
                  }
                }}
              if(exproute.isNotEmpty ){
                routeListList.add(exproute);
              }
              await busRoute(start: start,end:end).then((value) {
                value!.forEach((element) {
                  exproute1.add(element);
                });
              });
              routeListList.add(exproute1);
              setState(() {
                isShow=true;
              });
            }
            Get.to(() =>  PlanRouteScreen(exproute:routeListList), arguments: [
              widget.originLatLong,
              widget.destinationLatLang,
              widget.originAddress,
              widget.destinationAddress,
            ]);
          },
          child: Text(
            "Search Routes",
            style: TextStyle(
                fontSize: 14,
                fontWeight: CustomFontWeight.kBoldFontWeight,
                color: CustomColor.kWhite),
          ),
        ),
      ),
    );
  }
}