import 'dart:convert';

import 'package:admission_flutter/models/responses/Response.dart';

class ResponseWithToken extends Response{

  final int abiturient_id;
  final String token;

  ResponseWithToken({
    Object? content,
    String? failure_message,
    required bool result,
    required this.abiturient_id,
    required this.token,
  }) :super(content: content, failure_message: failure_message, result: result);

  factory ResponseWithToken.fromJson(Map <String, dynamic> json) {
    return ResponseWithToken(
        content: json['content'],
        failure_message: json['failure_message'],
        result: json['result'],
        abiturient_id: json['abiturient_id'],
        token: json['token']
    );
  }
}