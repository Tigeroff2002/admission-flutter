import 'dart:convert';

import 'package:admission_flutter/models/responses/ResponseWithToken.dart';

class AddNewDirectionResponse extends ResponseWithToken{

  final int direction_id;

  AddNewDirectionResponse({
    Object? content,
    String? failure_message,
    required bool result,
    required int abiturient_id,
    required String token,
    required this.direction_id
  }) :super(content: content, failure_message: failure_message, result: result, abiturient_id: abiturient_id, token: token);

  factory AddNewDirectionResponse.fromJson(Map <String, dynamic> json) {
    return AddNewDirectionResponse(
        content: json['content'],
        failure_message: json['failure_message'],
        result: json['result'],
        abiturient_id: json['abiturient_id'],
        token: json['token'],
        direction_id: json['direction_id']
    );
  }
}