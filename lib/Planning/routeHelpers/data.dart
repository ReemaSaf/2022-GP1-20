// ignore_for_file: camel_case_types, non_constant_identifier_names

List<String> Line_1=['Line_4','Line_2','Line_5','Line_3'];
List<String> Line_2=['Line_1','Line_6','Line_5',];
List<String> Line_3=['Line_1','Line_6',];
List<String> Line_4=['Line_1','Line_6',];
List<String> Line_5=['Line_1','Line_2',];
List<String> Line_6=['Line_1','Line_4','Line_2','Line_3'];


List getLineList({String? list}){
  if(list=='Line_1'){
    return Line_1;
  } else if(list=='Line_2'){
    return Line_2;
  } else if(list=='Line_3'){
    return Line_3;
  }  else if(list=='Line_4'){
    return Line_4;
  }  else if(list=='Line_5'){
    return Line_5;
  }else{
    return Line_6;
  }
}

class busDistance{
  double? dis;
  String? name;
  int? number;
  busDistance({this.dis,this.name,this.number});
}

