import 'dart:convert';

import 'package:admission_flutter/models/responses/DirectionSnapshotContent.dart';

class GetAllAbiturientsResponse{

  final DirectionSnapshotContent? content;
  final String? failure_message;
  final bool result;
  final int abiturient_id;
  final String token;

  GetAllAbiturientsResponse({
    this.content,
    this.failure_message,
    required this.result,
    required this.abiturient_id,
    required this.token,
  });

  factory GetAllAbiturientsResponse.fromJson(Map <String, dynamic> json) {
    return GetAllAbiturientsResponse(
        content: json['content'],
        failure_message: json['failure_message'],
        result: json['result'],
        abiturient_id: json['abiturient_id'],
        token: json['token']
    );
  }
}