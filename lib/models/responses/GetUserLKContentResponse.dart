import 'dart:convert';

import 'package:admission_flutter/models/responses/UserLKContent.dart';

class GetUserLKContentResponse{

  final UserLKContent? content;
  final String? failure_message;
  final bool result;
  final int abiturient_id;
  final String token;

  GetUserLKContentResponse({
    this.content,
    this.failure_message,
    required this.result,
    required this.abiturient_id,
    required this.token,
  });

  factory GetUserLKContentResponse.fromJson(Map <String, dynamic> json) {
    return GetUserLKContentResponse(
        content: json['content'],
        failure_message: json['failure_message'],
        result: json['result'],
        abiturient_id: json['abiturient_id'],
        token: json['token']
    );
  }
}