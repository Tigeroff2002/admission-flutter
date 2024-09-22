import 'dart:convert';

class UserRegisterModelRequest {

  final String email;
  final String password;
  final String first_name;
  final String second_name;
  final bool is_admin;

  UserRegisterModelRequest({
    required this.email,
    required this.password,
    required this.first_name,
    required this.second_name,
    required this.is_admin
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'first_name': first_name,
      'second_name': second_name,
      'is_admin': is_admin
    };
  }

  String serialize() {
    return jsonEncode(toJson());
  }
}