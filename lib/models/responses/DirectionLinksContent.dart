import 'dart:convert';

import 'package:admission_flutter/models/responses/DirectionLink.dart';

class DirectionLinksContent{

  final List<DirectionLink> directions;

  DirectionLinksContent({
    required this.directions
  });

  factory DirectionLinksContent.fromJson(Map <String, dynamic> json) {
    return DirectionLinksContent(
      directions: json['directions']
    );
  }
}