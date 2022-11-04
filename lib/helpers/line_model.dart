import 'dart:convert';
// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names

class LineModel {
  String Color;
  double Distance;

  LineModel({
    required this.Color,
    required this.Distance,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Color': Color,
      'Distance': Distance,
    };
  }

  factory LineModel.fromMap(Map<String, dynamic> map) {
    return LineModel(
      Color: map['Color'],
      Distance: double.parse((map['Distance'].toString())),
    );
  }

  String toJson() => json.encode(toMap());

  factory LineModel.fromJson(String source) =>
      LineModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
