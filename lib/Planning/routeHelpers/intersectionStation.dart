// ignore: file_names
// ignore_for_file: avoid_function_literals_in_foreach_calls, file_names, duplicate_ignore

import '../../main.dart';
import 'intersection.dart';

Future<IntersectionModel?> intersectionStation({String? startingLine,String? endingLine}) async {
  List<String> nameList=[];
  List<String> intersection=[];
  IntersectionModel? intersectionLine;
  await metroService.containsAssending().then((value){
    value.forEach((element) {
      if(element.Line_ID.id==startingLine){
        nameList.add(element.Name);
      }
    });
  });

  await metroService.containsAssending().then((value){
    value.forEach((e) {
      if(e.Line_ID.id==endingLine){
        nameList.forEach((element) {
          if(e.Name==element){
            intersection.add(e.Name);
            intersectionLine=IntersectionModel(Name: e.Name,Line_ID:e.Line_ID,MStation_ID: e.MStation_ID,OrderE:e.Order);
          }
        });
      }
    });
  });
  await metroService.containsAssending().then((value) {
    value.forEach((element) {
      if(element.Name==intersection[0] && element.Line_ID.id==startingLine){
        intersectionLine!.OrderS=element.Order;
      }
    });
  });
  return intersectionLine;
}