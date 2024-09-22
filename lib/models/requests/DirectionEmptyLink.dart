import 'dart:convert';

class DirectionEmptyLink{

  final int direction_id;
  final int prioritet_number;
  final int mark;

  DirectionEmptyLink({
    required this.direction_id,
    required this.prioritet_number,
    required this.mark
  });

  Map<String, dynamic> toJson() {
    return {
      'direction_id': direction_id,
      'prioritet_number': prioritet_number,
      'mark': mark
    };
  }

  String serialize() {
    return jsonEncode(toJson());
  }
}