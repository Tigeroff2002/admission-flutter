import 'package:admission_flutter/models/requests/RequestWithToken.dart';
import 'dart:convert';

class UserLKModelRequest extends RequestWithToken{

  UserLKModelRequest({
    required int abiturient_id,
    required String token,
  })
      : super(abiturient_id: abiturient_id, token: token);

  Map<String, dynamic> toJson() {
    return {
      'abiturient_id': abiturient_id,
      'token': token
    };
  }
}