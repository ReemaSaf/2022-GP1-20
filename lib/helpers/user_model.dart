import 'dart:convert';

class UserModel {
  String email;
  String firstName;
  String lastName;
  String? password;
  String? imageUrl;
  UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    this.password,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'email': email});
    result.addAll({'firstName': firstName});
    result.addAll({'lastName': lastName});
    if(password != null){
      result.addAll({'password': password});
    }
    if(imageUrl != null){
      result.addAll({'imageUrl': imageUrl});
    }
  
    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      password: map['password'],
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
