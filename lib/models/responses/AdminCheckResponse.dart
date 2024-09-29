import 'dart:convert';

import 'package:admission_flutter/models/responses/ResponseWithToken.dart';

class AdminCheckResponse extends ResponseWithToken{

  final bool is_admin;

  AdminCheckResponse({
    Object? content,
    String? failure_message,
    required bool result,
    required int abiturient_id,
    required String token,
    required this.is_admin
  }) :super(content: content, failure_message: failure_message, result: result, abiturient_id: abiturient_id, token: token);

  factory AdminCheckResponse.fromJson(Map <String, dynamic> json) {
    return AdminCheckResponse(
        content: json['content'],
        failure_message: json['failure_message'],
        result: json['result'],
        abiturient_id: json['abiturient_id'],
        token: json['token'],
        is_admin: json['is_admin']
    );
  }
}