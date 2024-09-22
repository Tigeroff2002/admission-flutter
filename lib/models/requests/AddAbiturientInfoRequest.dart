import 'dart:convert';

import 'package:admission_flutter/models/requests/AbiturientInfoContent.dart';
import 'package:admission_flutter/models/requests/RequestWithToken.dart';

class AddAbiturientInfoRequest extends RequestWithToken {

  final AbiturientInfoContent content;

  AddAbiturientInfoRequest({
    required int abiturient_id,
    required String token,
    required this.content
  }) : super(abiturient_id: abiturient_id, token: token);

  Map<String, dynamic> toJson() {
    return {
      'abiturient_id': abiturient_id,
      'token': token,
      'content': content
    };
  }

  String serialize() {
    return jsonEncode(toJson());
  }
}