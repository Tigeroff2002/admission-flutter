import 'dart:convert';

import 'package:admission_flutter/models/requests/RequestWithToken.dart';

class AddNewDirectionRequest extends RequestWithToken {

  final String direction_caption;
  final int budget_places_number;
  final int min_ball;

  AddNewDirectionRequest({
    required int abiturient_id,
    required String token,
    required this.direction_caption,
    required this.budget_places_number,
    required this.min_ball
  }) : super(abiturient_id: abiturient_id, token: token);

  Map<String, dynamic> toJson() {
    return {
      'abiturient_id': abiturient_id,
      'token': token,
      'direction_caption': direction_caption
    };
  }

  String serialize() {
    return jsonEncode(toJson());
  }
}