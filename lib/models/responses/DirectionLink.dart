import 'dart:convert';

class DirectionLink{

  final int direction_id;
  final String direction_caption;
  final bool is_filled;
  final bool is_finalized;

  DirectionLink({
    required this.direction_id,
    required this.direction_caption,
    this.is_filled = false,
    this.is_finalized = false
  });

  factory DirectionLink.fromJson(Map <String, dynamic> json) {
    return DirectionLink(
      direction_id: json['direction_id'],
      direction_caption: json['direction_caption']
    );
  }
}