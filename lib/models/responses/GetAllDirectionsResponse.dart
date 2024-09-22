import 'dart:convert';

import 'package:admission_flutter/models/responses/DirectionLinksContent.dart';

class GetAllDirectionsResponse{

  final DirectionLinksContent? content;
  final String? failure_message;
  final bool result;
  final int abiturient_id;
  final String token;

  GetAllDirectionsResponse({
    this.content,
    this.failure_message,
    required this.result,
    required this.abiturient_id,
    required this.token,
  });

  factory GetAllDirectionsResponse.fromJson(Map <String, dynamic> json) {
    return GetAllDirectionsResponse(
        content: json['content'],
        failure_message: json['failure_message'],
        result: json['result'],
        abiturient_id: json['abiturient_id'],
        token: json['token']
    );
  }
}