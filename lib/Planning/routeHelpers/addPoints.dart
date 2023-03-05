// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls, avoid_print

import 'package:sekkah_app/Planning/routeHelpers/intersection.dart';

import '../../helpers/contains_model.dart';
import '../../helpers/route_model.dart';
import '../../main.dart';

Future<List<RouteModel>?> addPoints({ContainsModel? startingLine,ContainsModel? endLine}) async {
  List<String> nameList=[];
  bool? isAdd=false;
  List<RouteModel> exproute=[];
  if(int.parse(startingLine!.Order)>int.parse(endLine!.Order)) {
    await metroService.containsDescending().then((value) {
      value.forEach((e) async {
        if (e.Line_ID.id == startingLine.Line_ID.id) {
          print("=========== ${e.Name} ===== ${e.Line_ID.id} &&& ${e.Order}");
          nameList.add(e.Name);
        }
      });
    });
  }else{
    await  metroService.containsAssending().then((value){
      value.forEach((e) async {
        if(e.Line_ID.id==startingLine.Line_ID.id){
          print("=========== ${e.Name} ===== ${e.Line_ID.id} &&& ${e.Order}");
          nameList.add(e.Name);

        }
      });
    });
  }

  for (var element in nameList)  {
    await metroService.getMetroStation(Name: element).then((v){
      v.forEach((element) {
        print("+++++++++++++++++++++++++++++++ ${element.Name} &&& ${element.Location.latitude} &&& ${element.Location.longitude}");
        if(element.Name==startingLine.Name || element.Name==endLine.Name){
          isAdd=true;
        }
        if(isAdd==true){
          exproute.add(RouteModel(type: 'metro',isShow: true,name: element.Name,lat: element.Location.latitude,lng: element.Location.longitude));
          if(element.Name==endLine.Name ){
            isAdd=false;
          }
        }
      });

    });
  }
  return exproute;
}

Future<List<RouteModel>?> intersationAddPoints({ContainsModel? startingLine,ContainsModel? endLine,IntersectionModel? i1,IntersectionModel? i2}) async {
  List<String> nameList=[];
  bool? isAdd=false;
  List<RouteModel> exproute=[];
  if(int.parse(startingLine!.Order)>int.parse(i1!.OrderS!)) {
    await metroService.containsDescending().then((value) {
      value.forEach((e) async {
        if (e.Line_ID.id == startingLine.Line_ID.id) {
          print("=========== ${e.Name} ===== ${e.Line_ID.id} &&& ${e.Order}");
          nameList.add(e.Name);
        }
      });
    });
  }else{
    await  metroService.containsAssending().then((value){
      value.forEach((e) async {
        if(e.Line_ID.id==startingLine.Line_ID.id){
          print("=========== ${e.Name} ===== ${e.Line_ID.id} &&& ${e.Order}");
          nameList.add(e.Name);
        }
      });
    });
  }

  for (var element in nameList)  {
    await metroService.getMetroStation(Name: element).then((v){
      v.forEach((element) {
        print("+++++++++++++++++++++++++++++++ ${element.Name} &&& ${element.Location.latitude} &&& ${element.Location.longitude}");
        if(element.Name==startingLine.Name || element.Name==i1.Name){
          isAdd=true;
        }
        if(isAdd==true){
          exproute.add(RouteModel(type: 'metro',isShow: true,name: element.Name,lat: element.Location.latitude,lng: element.Location.longitude));
          if(element.Name==i1.Name ){
            isAdd=false;
          }
        }
      });

    });
  }
  return exproute;
}



Future<List<RouteModel>?> intersationAddPoints1({IntersectionModel? i1,IntersectionModel? i2}) async {
  List<String> nameList=[];
  bool? isAdd=false;
  List<RouteModel> exproute=[];
  print("this is the intersection ordrr sdkdjfkdjfldjflk ======= ${i1!.Name} ${i1!.OrderS} === ${i1!.OrderE}");
  print("this is the intersection ordrr sdkdjfkdjfldjflk ======= ${i2!.Name} ${i2!.OrderS} === ${i2!.OrderE}");
  if(int.parse(i1!.OrderE!)>int.parse(i2!.OrderE!)) {
    await metroService.containsDescending().then((value) {
      value.forEach((e) async {
        if (e.Line_ID.id == i1.Line_ID!.id) {
          print("=========== ${e.Name} ===== ${e.Line_ID.id} &&& ${e.Order}");
          nameList.add(e.Name);
        }
      });
    });
    for (var element in nameList)  {
      await metroService.getMetroStation(Name: element).then((v){
        v.forEach((element) {
          print("+++++++++++++++++++++++++++++++ ${element.Name} &&& ${element.Location.latitude} &&& ${element.Location.longitude}");
          if(element.Name==i1.Name){
            isAdd=true;
          }
          if(isAdd==true){
            exproute.add(RouteModel(type: 'metro',isShow: true,name: element.Name,lat: element.Location.latitude,lng: element.Location.longitude));
            if(element.Name==i2.Name ){
              isAdd=false;
            }
          }
        });

      });
    }
  }else{
    await  metroService.containsAssending().then((value){
      value.forEach((e) async {
        if(e.Line_ID.id==i1.Line_ID!.id){
          print("=========== ${e.Name} ===== ${e.Line_ID.id} &&& ${e.Order}");
          nameList.add(e.Name);
        }
      });
    });
    for (var element in nameList)  {
      await metroService.getMetroStation(Name: element).then((v){
        v.forEach((element) {
          print("+++++++++++++++++++++++++++++++ ${element.Name} &&& ${element.Location.latitude} &&& ${element.Location.longitude}");
          if(element.Name==i1.Name || element.Name==i2.Name){
            isAdd=true;
          }
          if(isAdd==true){
            exproute.add(RouteModel(type: 'metro',isShow: true,name: element.Name,lat: element.Location.latitude,lng: element.Location.longitude));
            if(element.Name==i2.Name ){
              isAdd=false;
            }
          }
        });

      });
    }
  }

  return exproute;
}

Future<List<RouteModel>?> intersationAddPoints2({ContainsModel? endLine,IntersectionModel? i2}) async {
  List<String> nameList=[];
  bool? isAdd=false;
  List<RouteModel> exproute=[];
  if(int.parse(i2!.OrderS!)>int.parse(endLine!.Order)) {
    await metroService.containsDescending().then((value) {
      value.forEach((e) async {
        if (e.Line_ID.id ==endLine.Line_ID.id) {
          print("=========== ${e.Name} ===== ${e.Line_ID.id} &&& ${e.Order}");
          nameList.add(e.Name);
        }
      });
    });
  }else{
    await  metroService.containsAssending().then((value){
      value.forEach((e) async {
        if(e.Line_ID.id==endLine.Line_ID.id){
          print("=========== ${e.Name} ===== ${e.Line_ID.id} &&& ${e.Order}");
          nameList.add(e.Name);
        }
      });
    });
  }

  for (var element in nameList)  {
    await metroService.getMetroStation(Name: element).then((v){
      v.forEach((element) {
        print("+++++++++++++++++++++++++++++++ ${element.Name} &&& ${element.Location.latitude} &&& ${element.Location.longitude}");
        if(element.Name==endLine.Name || element.Name==i2.Name){
          isAdd=true;
        }
        if(isAdd==true){
          exproute.add(RouteModel(type: 'metro',isShow: true,name: element.Name,lat: element.Location.latitude,lng: element.Location.longitude));
          if(element.Name==endLine.Name){
            isAdd=false;
          }
        }
      });

    });
  }
  return exproute;
}