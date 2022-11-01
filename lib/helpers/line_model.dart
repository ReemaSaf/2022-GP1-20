import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
class LineModel {
  double Distance;
  String Name;
  LineModel({
    required this.Distance,
    required this.Name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Distance': Distance,
      'Name': Name,
    };
  }

  factory LineModel.fromMap(Map<String, dynamic> map) {
    return LineModel(
      Distance: double.parse((map['Distance'].toString())),
      Name: map['Name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LineModel.fromJson(String source) =>
      LineModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
