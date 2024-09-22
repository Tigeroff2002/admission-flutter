import 'dart:convert';

import 'package:admission_flutter/models/requests/RequestWithToken.dart';

class FinalizeDirectionRequest extends RequestWithToken {

  final int direction_id;

  FinalizeDirectionRequest({
    required int abiturient_id,
    required String token,
    required this.direction_id
  }) : super(abiturient_id: abiturient_id, token: token);

  Map<String, dynamic> toJson() {
    return {
      'abiturient_id': abiturient_id,
      'token': token,
      'direction_id': direction_id
    };
  }

  String serialize() {
    return jsonEncode(toJson());
  }
}