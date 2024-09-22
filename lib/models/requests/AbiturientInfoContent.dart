import 'dart:convert';

import 'package:admission_flutter/models/requests/DirectionEmptyLink.dart';

class AbiturientInfoContent{

  final int target_abiturient_id;
  final bool has_diplom_original;
  final List<DirectionEmptyLink> directions_links;

  AbiturientInfoContent({
    required this.target_abiturient_id,
    required this.has_diplom_original,
    required this.directions_links
  });

  Map<String, dynamic> toJson() {
    return {
      'target_abiturient_id': target_abiturient_id,
      'has_diplom_original': has_diplom_original,
      'directions_links': directions_links
    };
  }

  String serialize() {
    return jsonEncode(toJson());
  }
}