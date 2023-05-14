// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class UserModel {
  String email;
  String firstName;
  String lastName;
  String? password;
  String? passType;

  String Pass_Expired_date = "0";
  UserModel(
      {required this.email,
      required this.firstName,
      required this.lastName,
      this.password,

      this.passType,
      
      this.Pass_Expired_date = "0"});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'firstName': firstName});
    result.addAll({'lastName': lastName});
    if (password != null) {
      result.addAll({'password': password});
    }
    if (passType != null) {
      result.addAll({'passType': passType});
    }

    result.addAll({'Pass_Expired_date': Pass_Expired_date});
    

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      password: map['password'],
      Pass_Expired_date: map['Pass_Expired_date'] ?? "0",
      passType: map['passType'] ?? '',
      
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
