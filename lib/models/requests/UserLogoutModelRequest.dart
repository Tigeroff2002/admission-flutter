import 'dart:convert';

import 'package:admission_flutter/models/requests/RequestWithToken.dart';

class UserLogoutModelRequest extends RequestWithToken {

  UserLogoutModelRequest({
    required int abiturient_id,
    required String token
  }) : super(abiturient_id: abiturient_id, token: token);

  Map<String, dynamic> toJson() {
    return {
      'abiturient_id': abiturient_id,
      'token': token,
    };
  }

  String serialize() {
    return jsonEncode(toJson());
  }
}