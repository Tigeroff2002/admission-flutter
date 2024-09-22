import 'dart:convert';

import 'package:admission_flutter/models/responses/PlaceLink.dart';

class DirectionSnapshotContent{

  final int direction_id;
  final String direction_caption;
  final int budget_places_number;
  final int min_ball;
  final List<PlaceLink> places;

  DirectionSnapshotContent({
    required this.direction_id,
    required this.direction_caption,
    required this.budget_places_number,
    required this.min_ball,
    required this.places
  });

  factory DirectionSnapshotContent.fromJson(Map <String, dynamic> json) {
    return DirectionSnapshotContent(
      direction_id: json['direction_id'],
      direction_caption: json['direction_caption'],
      budget_places_number: json['budget_places_number'],
      min_ball: json['min_ball'],
      places: json['places']
    );
  }
}