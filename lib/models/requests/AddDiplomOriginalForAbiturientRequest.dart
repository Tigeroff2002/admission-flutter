import 'dart:convert';

import 'package:admission_flutter/models/requests/RequestWithToken.dart';

class AddDiplomOriginalForAbiturientRequest extends RequestWithToken {

  final int target_abiturient_id;
  final bool has_diplom_original;

  AddDiplomOriginalForAbiturientRequest({
    required int abiturient_id,
    required String token,
    required this.target_abiturient_id,
    required this.has_diplom_original
  }) : super(abiturient_id: abiturient_id, token: token);

  Map<String, dynamic> toJson() {
    return {
      'abiturient_id': abiturient_id,
      'token': token,
      'target_abiturient_id': target_abiturient_id,
      'has_diplom_original': has_diplom_original
    };
  }

  String serialize() {
    return jsonEncode(toJson());
  }
}