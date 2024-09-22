import 'dart:convert';

class UserLoginModelRequest {

  final String email;
  final String password;

  UserLoginModelRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password
    };
  }

  String serialize() {
    return jsonEncode(toJson());
  }
}