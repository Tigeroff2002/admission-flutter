import 'dart:convert';

class AbiturientPlaceLink{

  final int place;
  final int direction_id;
  final String direction_caption;
  final int mark;
  final String admission_status;
  final int prioritet_number;

  AbiturientPlaceLink({
    required this.place,
    required this.direction_id,
    required this.direction_caption,
    required this.mark,
    required this.admission_status,
    required this.prioritet_number
  });

  factory AbiturientPlaceLink.fromJson(Map <String, dynamic> json) {
    return AbiturientPlaceLink(
      place: json['place'],
      direction_id: json['direction_id'],
      direction_caption: json['direction_caption'],
      mark: json['mark'],
      admission_status: json['admission_status'],
      prioritet_number: json['prioritet_number'],
    );
  }
}