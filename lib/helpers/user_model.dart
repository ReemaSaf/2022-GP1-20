// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class UserModel {
  String email;
  String firstName;
  String lastName;
  String? password;
  String? imageUrl;
  String? passType;
  int price = 0;
  String Pass_Expired_date = "0";
  UserModel(
      {required this.email,
      required this.firstName,
      required this.lastName,
      this.password,
      this.imageUrl,
      this.passType,
      this.price = 0,
      this.Pass_Expired_date = "0"});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'firstName': firstName});
    result.addAll({'lastName': lastName});
    if (password != null) {
      result.addAll({'password': password});
    }
    if (imageUrl != null) {
      result.addAll({'imageUrl': imageUrl});
    }
    if (passType != null) {
      result.addAll({'passType': passType});
    }

    result.addAll({'Pass_Expired_date': Pass_Expired_date});
    result.addAll({'price': price});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      password: map['password'],
      imageUrl: map['imageUrl'],
      Pass_Expired_date: map['Pass_Expired_date'] ?? "0",
      passType: map['passType'] ?? '',
      price: map['price'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
